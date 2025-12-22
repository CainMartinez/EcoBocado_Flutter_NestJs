import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ConfigService } from '@nestjs/config';
import { Repository, SelectQueryBuilder } from 'typeorm';
import { Product } from '../../../domain/entities/product.entity';
import { IProductRepository } from '../../../domain/repositories/product.repository';
import { CatalogFilters, PaginatedResult } from '../../../domain/types/catalog-filters.type';
import { ProductWithDetails } from '../../../domain/types/catalog-types.type';
import { ProductOrmEntity } from '../entities-orm/product.orm-entity';

@Injectable()
export class ProductTypeOrmRepository extends IProductRepository {
  constructor(
    @InjectRepository(ProductOrmEntity)
    private readonly repository: Repository<ProductOrmEntity>,
    private readonly configService: ConfigService,
  ) {
    super();
  }

  async findAllVisible(): Promise<Product[]> {
    const records = await this.repository.find({
      where: { isActive: true },
      relations: ['category'],
      order: { id: 'ASC' },
    });

    return records.map((record) => this.toDomain(record));
  }

  async findWithFilters(filters: CatalogFilters): Promise<PaginatedResult<ProductWithDetails>> {
    const limit = filters.limit || 20;
    
    // Query principal
    const query = this.repository
      .createQueryBuilder('product')
      .leftJoinAndSelect('product.category', 'category')
      .where('product.isActive = :isActive', { isActive: true });

    // Aplicar filtros
    this.applyFilters(query, filters);

    // Aplicar ordenamiento
    this.applySorting(query, filters);

    // Cursor pagination
    if (filters.cursor) {
      query.andWhere('product.id > :cursor', { cursor: filters.cursor });
    }

    // Obtener total antes de paginar
    const total = await query.getCount();

    // Aplicar límite (+1 para saber si hay más páginas)
    query.limit(limit + 1);

    // Ejecutar query
    const records = await query.getMany();

    // Determinar si hay más páginas
    const hasMore = records.length > limit;
    const items = hasMore ? records.slice(0, limit) : records;
    const nextCursor = hasMore && items.length > 0 ? items[items.length - 1].id : null;

    // Obtener alérgenos para cada producto
    const productsWithAllergens = await this.enrichWithAllergens(items);

    return {
      items: productsWithAllergens,
      total,
      nextCursor,
    };
  }

  private applyFilters(query: SelectQueryBuilder<ProductOrmEntity>, filters: CatalogFilters): void {
    // Filtro por categoría
    if (filters.categoryCode) {
      query.andWhere('category.code = :categoryCode', { categoryCode: filters.categoryCode });
    }

    // Filtro por vegano
    if (filters.isVegan !== undefined) {
      // Convertir explícitamente a número para MySQL tinyint
      const veganValue = filters.isVegan ? 1 : 0;
      query.andWhere('product.is_vegan = :isVegan', { isVegan: veganValue });
    }

    // Filtro por alérgenos (INVERSO: excluir productos que contengan estos alérgenos)
    // IMPORTANTE: mayContain se trata igual que contains por seguridad
    if (filters.excludeAllergens && filters.excludeAllergens.length > 0) {      
      // Ensure it's an array
      const allergensList = Array.isArray(filters.excludeAllergens) 
        ? filters.excludeAllergens 
        : [filters.excludeAllergens];
      
      query.andWhere((qb) => {
        const subQuery = qb
          .subQuery()
          .select('pa.productId')
          .from('product_allergen', 'pa')
          .where('pa.allergenCode IN (:...allergens)', { allergens: allergensList })
          .andWhere('(pa.contains = true OR pa.mayContain = true)')
          .getQuery();
        return `product.id NOT IN ${subQuery}`;
      });
    }
  }

  private applySorting(query: SelectQueryBuilder<ProductOrmEntity>, filters: CatalogFilters): void {
    const sortBy = filters.sortBy || 'createdAt';
    const sortOrder = filters.sortOrder || 'asc';

    switch (sortBy) {
      case 'price':
        query.orderBy('product.price', sortOrder.toUpperCase() as 'ASC' | 'DESC');
        break;
      case 'name':
        query.orderBy('product.nameEs', sortOrder.toUpperCase() as 'ASC' | 'DESC');
        break;
      case 'createdAt':
      default:
        query.orderBy('product.createdAt', sortOrder.toUpperCase() as 'ASC' | 'DESC');
        break;
    }
    // Ordenamiento secundario por ID para garantizar consistencia
    query.addOrderBy('product.id', 'ASC');
  }

  private async enrichWithAllergens(products: ProductOrmEntity[]): Promise<ProductWithDetails[]> {
    if (products.length === 0) return [];

    const productIds = products.map(p => p.id);

    // Obtener alérgenos con nombres para todos los productos en una sola query
    const allergens = await this.repository
      .createQueryBuilder('product')
      .leftJoin('product_allergen', 'pa', 'pa.productId = product.id')
      .leftJoin('allergens', 'a', 'a.code = pa.allergenCode')
      .select('product.id', 'productId')
      .addSelect('GROUP_CONCAT(DISTINCT CONCAT(pa.allergenCode, "|", a.name_es, "|", a.name_en, "|", pa.contains, "|", pa.mayContain))', 'allergens')
      .where('product.id IN (:...productIds)', { productIds })
      .andWhere('pa.isActive = true')
      .groupBy('product.id')
      .getRawMany();

    const allergensMap = new Map<number, Array<{ code: string; nameEs: string; nameEn: string; contains: boolean; mayContain: boolean }>>();
    allergens.forEach((row: any) => {
      if (row.allergens) {
        const allergenList = row.allergens.split(',').map((item: string) => {
          const [code, nameEs, nameEn, contains, mayContain] = item.split('|');
          return { 
            code, 
            nameEs, 
            nameEn,
            contains: contains === '1' || contains === 'true',
            mayContain: mayContain === '1' || mayContain === 'true',
          };
        });
        allergensMap.set(row.productId, allergenList);
      } else {
        allergensMap.set(row.productId, []);
      }
    });

    // Obtener imágenes para todos los productos en una sola query
    const images = await this.repository
      .createQueryBuilder('product')
      .leftJoin('images', 'img', 'img.product_id = product.id')
      .select('product.id', 'productId')
      .addSelect('GROUP_CONCAT(DISTINCT img.path)', 'images')
      .where('product.id IN (:...productIds)', { productIds })
      .andWhere('img.is_active = true')
      .groupBy('product.id')
      .getRawMany();

    const imagesMap = new Map<number, string[]>();
    const baseUrl = this.configService.get<string>('MINIO_PUBLIC_URL') || 'http://localhost:9000';
    
    images.forEach((row: any) => {
      const paths = row.images ? row.images.split(',') : [];
      // Construir URLs completas: baseUrl + path
      const fullUrls = paths.map((path: string) => `${baseUrl}${path}`);
      imagesMap.set(row.productId, fullUrls);
    });

    return products.map((product) => {
      const allergenCodes = allergensMap.get(product.id) || [];
      const imagePaths = imagesMap.get(product.id) || [];
      
      const baseProduct = Product.fromPrimitives({
        id: product.id,
        uuid: product.uuid,
        nameEs: product.nameEs,
        nameEn: product.nameEn,
        descriptionEs: product.descriptionEs,
        descriptionEn: product.descriptionEn,
        price: Number(product.price),
        currency: product.currency,
        isVegan: Boolean(product.isVegan),
        isActive: Boolean(product.isActive),
        categoryCode: product.category?.code,
        createdAt: product.createdAt,
        updatedAt: product.updatedAt,
      });

      // Construir objeto de categoría
      const categoryInfo = {
        code: product.category?.code || '',
        nameEs: product.category?.nameEs || '',
        nameEn: product.category?.nameEn || '',
      };

      return {
        ...baseProduct,
        allergens: allergenCodes,
        images: imagePaths,
        category: categoryInfo,
      };
    });
  }

  private toDomain(record: ProductOrmEntity): Product {
    return Product.fromPrimitives({
      id: record.id,
      uuid: record.uuid,
      nameEs: record.nameEs,
      nameEn: record.nameEn,
      descriptionEs: record.descriptionEs,
      descriptionEn: record.descriptionEn,
      price: Number(record.price),
      currency: record.currency,
      isVegan: Boolean(record.isVegan),
      isActive: Boolean(record.isActive),
      categoryCode: record.category?.code,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
    });
  }
}
