import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ConfigService } from '@nestjs/config';
import { Repository, SelectQueryBuilder } from 'typeorm';
import { RescueMenu } from '../../../domain/entities/rescue-menu.entity';
import { IRescueMenuRepository } from '../../../domain/repositories/rescue-menu.repository';
import { CatalogFilters, PaginatedResult } from '../../../domain/types/catalog-filters.type';
import { MenuWithDetails } from '../../../domain/types/catalog-types.type';
import { RescueMenuOrmEntity } from '../entities-orm/rescue-menu.orm-entity';

@Injectable()
export class RescueMenuTypeOrmRepository extends IRescueMenuRepository {
  constructor(
    @InjectRepository(RescueMenuOrmEntity)
    private readonly repository: Repository<RescueMenuOrmEntity>,
    private readonly configService: ConfigService,
  ) {
    super();
  }

  async findWithFilters(filters: CatalogFilters): Promise<PaginatedResult<MenuWithDetails>> {
    const limit = filters.limit || 20;
    const MENU_CATEGORY_CODE = 'MENUS';
    
    // Si se filtra por categoría y NO es 'MENUS', retornar vacío
    if (filters.categoryCode && filters.categoryCode.toUpperCase() !== MENU_CATEGORY_CODE) {
      return {
        items: [],
        total: 0,
        nextCursor: null,
      };
    }

    // Query principal
    const query = this.repository
      .createQueryBuilder('menu')
      .where('menu.isActive = :isActive', { isActive: true });

    // Aplicar filtros
    await this.applyFilters(query, filters);

    // Aplicar ordenamiento
    this.applySorting(query, filters);

    // Cursor pagination
    if (filters.cursor) {
      query.andWhere('menu.id > :cursor', { cursor: filters.cursor });
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

    // Enriquecer con alérgenos e imágenes
    const menusWithDetails = await this.enrichWithAllergens(items);

    return {
      items: menusWithDetails,
      total,
      nextCursor,
    };
  }

  private async applyFilters(query: SelectQueryBuilder<RescueMenuOrmEntity>, filters: CatalogFilters): Promise<void> {
    // Filtro por vegano
    if (filters.isVegan !== undefined) {
      // Convertir explícitamente a número para MySQL tinyint
      const veganValue = filters.isVegan ? 1 : 0;
      query.andWhere('menu.is_vegan = :isVegan', { isVegan: veganValue });
    }

    // Filtro por alérgenos (INVERSO: excluir menús cuyos productos contengan estos alérgenos)
    // IMPORTANTE: mayContain se trata igual que contains por seguridad
    if (filters.excludeAllergens && filters.excludeAllergens.length > 0) {
      
      // Ensure it's an array
      const allergensList = Array.isArray(filters.excludeAllergens) 
        ? filters.excludeAllergens 
        : [filters.excludeAllergens];
      
      // Un menú se excluye si CUALQUIERA de sus 4 productos contiene los alérgenos
      // Usar OR entre las 4 consultas para que si algún producto tiene el alérgeno, se excluya el menú
      query.andWhere((qb) => {
        const subQuery = qb
          .subQuery()
          .select('DISTINCT rm.id')
          .from('rescue_menus', 'rm')
          // Verificar bebida
          .leftJoin('product_allergen', 'pa1', 'pa1.productId = rm.drink_id AND pa1.allergenCode IN (:...allergens) AND (pa1.contains = true OR pa1.mayContain = true)', { allergens: allergensList })
          // Verificar entrante
          .leftJoin('product_allergen', 'pa2', 'pa2.productId = rm.starter_id AND pa2.allergenCode IN (:...allergens) AND (pa2.contains = true OR pa2.mayContain = true)')
          // Verificar principal
          .leftJoin('product_allergen', 'pa3', 'pa3.productId = rm.main_id AND pa3.allergenCode IN (:...allergens) AND (pa3.contains = true OR pa3.mayContain = true)')
          // Verificar postre
          .leftJoin('product_allergen', 'pa4', 'pa4.productId = rm.dessert_id AND pa4.allergenCode IN (:...allergens) AND (pa4.contains = true OR pa4.mayContain = true)')
          // Si alguno de los productos tiene el alérgeno, excluir el menú
          .where('pa1.productId IS NOT NULL OR pa2.productId IS NOT NULL OR pa3.productId IS NOT NULL OR pa4.productId IS NOT NULL')
          .getQuery();
        return `menu.id NOT IN ${subQuery}`;
      });
    }
  }

  private applySorting(query: SelectQueryBuilder<RescueMenuOrmEntity>, filters: CatalogFilters): void {
    const sortBy = filters.sortBy || 'createdAt';
    const sortOrder = filters.sortOrder || 'asc';

    switch (sortBy) {
      case 'price':
        query.orderBy('menu.price', sortOrder.toUpperCase() as 'ASC' | 'DESC');
        break;
      case 'name':
        query.orderBy('menu.nameEs', sortOrder.toUpperCase() as 'ASC' | 'DESC');
        break;
      case 'createdAt':
      default:
        query.orderBy('menu.createdAt', sortOrder.toUpperCase() as 'ASC' | 'DESC');
        break;
    }
    // Ordenamiento secundario por ID para garantizar consistencia
    query.addOrderBy('menu.id', 'ASC');
  }

  private async enrichWithAllergens(menus: RescueMenuOrmEntity[]): Promise<MenuWithDetails[]> {
    if (menus.length === 0) return [];

    const menuIds = menus.map(m => m.id);

    // Obtener todos los product IDs de los menús
    const productIds = menus.flatMap(m => [
      m.drinkId,
      m.starterId,
      m.mainId,
      m.dessertId,
    ]);

    // Obtener alérgenos con nombres de todos los productos del menú
    // Obtenemos todos los alérgenos de los productos y luego consolidamos en TypeScript
    const allergens = await this.repository
      .createQueryBuilder('menu')
      .leftJoin('product_allergen', 'pa', 
        'pa.productId = menu.drink_id OR pa.productId = menu.starter_id OR pa.productId = menu.main_id OR pa.productId = menu.dessert_id')
      .leftJoin('allergens', 'a', 'a.code = pa.allergenCode')
      .select('menu.id', 'menuId')
      .addSelect('pa.allergenCode', 'allergenCode')
      .addSelect('a.name_es', 'nameEs')
      .addSelect('a.name_en', 'nameEn')
      .addSelect('pa.contains', 'contains')
      .addSelect('pa.mayContain', 'mayContain')
      .where('menu.id IN (:...menuIds)', { menuIds })
      .andWhere('pa.isActive = true')
      .getRawMany();

    // Consolidar alérgenos por menú
    // Si algún producto del menú tiene contains=true para un alérgeno, el menú lo contiene
    // Si ninguno tiene contains=true pero alguno tiene mayContain=true, el menú puede contenerlo
    const menuAllergens = new Map<number, Map<string, { code: string; nameEs: string; nameEn: string; contains: boolean; mayContain: boolean }>>();
    
    allergens.forEach((row: any) => {
      const menuId = row.menuId;
      const code = row.allergenCode;
      const nameEs = row.nameEs;
      const nameEn = row.nameEn;
      const contains = row.contains === 1 || row.contains === true;
      const mayContain = row.mayContain === 1 || row.mayContain === true;
      
      if (!menuAllergens.has(menuId)) {
        menuAllergens.set(menuId, new Map());
      }
      
      const allergenMap = menuAllergens.get(menuId)!;
      const existing = allergenMap.get(code);
      
      if (!existing) {
        allergenMap.set(code, { code, nameEs, nameEn, contains, mayContain });
      } else {
        // Combinar valores: si alguno tiene contains=true, el resultado es contains=true
        allergenMap.set(code, {
          code,
          nameEs,
          nameEn,
          contains: existing.contains || contains,
          mayContain: existing.mayContain || mayContain,
        });
      }
    });
    
    // Convertir el mapa a la estructura final
    const allergensMap = new Map<number, Array<{ code: string; nameEs: string; nameEn: string; contains: boolean; mayContain: boolean }>>();
    
    menuAllergens.forEach((allergenMap, menuId) => {
      const allergenArray = Array.from(allergenMap.values());
      allergensMap.set(menuId, allergenArray);
    });
    
    // Inicializar menús sin alérgenos
    menuIds.forEach(id => {
      if (!allergensMap.has(id)) {
        allergensMap.set(id, []);
      }
    });

    // Obtener imágenes de los menús
    const images = await this.repository
      .createQueryBuilder('menu')
      .leftJoin('images', 'img', 'img.menu_id = menu.id')
      .select('menu.id', 'menuId')
      .addSelect('GROUP_CONCAT(DISTINCT img.path)', 'images')
      .where('menu.id IN (:...menuIds)', { menuIds })
      .andWhere('img.is_active = true')
      .groupBy('menu.id')
      .getRawMany();

    const imagesMap = new Map<number, string[]>();
    const baseUrl = this.configService.get<string>('MINIO_PUBLIC_URL') || 'http://localhost:9000';
    
    images.forEach((row: any) => {
      const paths = row.images ? row.images.split(',') : [];
      // Construir URLs completas: baseUrl + path
      const fullUrls = paths.map((path: string) => `${baseUrl}${path}`);
      imagesMap.set(row.menuId, fullUrls);
    });

    return menus.map((menu) => {
      const allergenCodes = allergensMap.get(menu.id) || [];
      const imagePaths = imagesMap.get(menu.id) || [];
      
      const baseMenu = RescueMenu.fromPrimitives({
        id: menu.id,
        uuid: menu.uuid,
        nameEs: menu.nameEs,
        nameEn: menu.nameEn,
        descriptionEs: menu.descriptionEs,
        descriptionEn: menu.descriptionEn,
        drinkProductId: menu.drinkId,
        starterProductId: menu.starterId,
        mainProductId: menu.mainId,
        dessertProductId: menu.dessertId,
        price: Number(menu.price),
        currency: menu.currency,
        isVegan: Boolean(menu.isVegan),
        isActive: Boolean(menu.isActive),
        createdAt: menu.createdAt,
        updatedAt: menu.updatedAt,
      });

      // Construir objeto de categoría para menús
      const categoryInfo = {
        code: 'MENUS',
        nameEs: 'Menús',
        nameEn: 'Menus',
      };

      return {
        ...baseMenu,
        allergens: allergenCodes,
        images: imagePaths,
        category: categoryInfo,
      };
    });
  }
}
