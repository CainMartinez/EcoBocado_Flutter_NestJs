import { Controller, Get, HttpCode, Query, Request, UseGuards } from '@nestjs/common';
import { ApiOkResponse, ApiOperation, ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ConfigService } from '@nestjs/config';
import { QueryCatalogUseCase } from '../../application/use_cases/query-catalog.usecase';
import { QueryCatalogRequestDto } from '../../application/dto/request/query-catalog.request.dto';
import { PaginatedResponseDto } from '../../application/dto/response/paginated.response.dto';
import { CatalogItemResponseDto } from '../../application/dto/response/catalog-item.response.dto';
import { AllergenResponseDto } from '../../application/dto/response/allergen.response.dto';
import { CategoryResponseDto } from '../../application/dto/response/category.response.dto';
import { CatalogAssembler } from '../assemblers/catalog.assembler';
import { AllergenOrmEntity } from '../../infrastructure/typeorm/entities-orm/allergen.orm-entity';
import { CategoryOrmEntity } from '../../infrastructure/typeorm/entities-orm/category.orm-entity';
import { RescueMenuOrmEntity } from '../../infrastructure/typeorm/entities-orm/rescue-menu.orm-entity';
import { OptionalJwtAuthGuard } from '../../../auth/presentation/guards/optional-jwt-auth.guard';
import { USER_ALLERGEN_REPOSITORY_TOKEN } from '../../../profile/domain/repositories/user-allergen.repository.interface';
import type { IUserAllergenRepository } from '../../../profile/domain/repositories/user-allergen.repository.interface';
import { Inject } from '@nestjs/common';

@ApiTags('Shop')
@Controller('products')
export class ProductsController {
  constructor(
    private readonly queryCatalogUseCase: QueryCatalogUseCase,
    private readonly catalogAssembler: CatalogAssembler,
    private readonly configService: ConfigService,
    @InjectRepository(AllergenOrmEntity)
    private readonly allergenRepository: Repository<AllergenOrmEntity>,
    @InjectRepository(CategoryOrmEntity)
    private readonly categoryRepository: Repository<CategoryOrmEntity>,
    @InjectRepository(RescueMenuOrmEntity)
    private readonly rescueMenuRepository: Repository<RescueMenuOrmEntity>,
    @Inject(USER_ALLERGEN_REPOSITORY_TOKEN)
    private readonly userAllergenRepository: IUserAllergenRepository,
  ) {}

  @Get()
  @UseGuards(OptionalJwtAuthGuard)
  @HttpCode(200)
  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Catálogo unificado de productos y menús',
    description:
      'Devuelve un catálogo paginado con productos y menús. Soporta filtrado por categoría (category), vegano (isVegan), alérgenos inverso (excludeAllergens), y ordenamiento (sortBy, sortOrder). ' +
      'Si el usuario está autenticado, se aplicará automáticamente el filtrado de sus alérgenos configurados en el perfil para su protección. ' +
      'Usa cursor pagination para scroll infinito.',
  })
  @ApiOkResponse({
    description: 'Catálogo paginado de productos y menús',
    type: PaginatedResponseDto<CatalogItemResponseDto>,
  })
  async getAll(
    @Query() filters: QueryCatalogRequestDto,
    @Request() req,
  ): Promise<PaginatedResponseDto<CatalogItemResponseDto>> {
    // Si el usuario está autenticado, obtener sus alérgenos y agregarlos al filtro
    let finalFilters = filters;
    
    if (req.user && req.user.sub) {
      const userId = parseInt(req.user.sub);
      const userAllergens = await this.userAllergenRepository.findAllergenCodesByUserId(userId);
      
      // Combinar los alérgenos del usuario con los del filtro manual (si los hay)
      if (userAllergens.length > 0) {
        const existingExclusions = filters.excludeAllergens || [];
        const allExclusions = [...new Set([...existingExclusions, ...userAllergens])];
        
        finalFilters = {
          ...filters,
          excludeAllergens: allExclusions,
        };
      }
    }
    
    const result = await this.queryCatalogUseCase.execute(finalFilters);
    return this.catalogAssembler.toPaginatedResponse(result);
  }

  @Get('allergens')
  @HttpCode(200)
  @ApiOperation({
    summary: 'Listar todos los alérgenos',
    description: 'Devuelve la lista completa de alérgenos disponibles',
  })
  @ApiOkResponse({
    description: 'Lista de alérgenos',
    type: AllergenResponseDto,
    isArray: true,
  })
  async getAllergens(): Promise<AllergenResponseDto[]> {
    const allergens = await this.allergenRepository.find({
      where: { isActive: true },
      order: { nameEs: 'ASC' },
    });

    return allergens.map((a) => ({
      code: a.code,
      nameEs: a.nameEs || a.code,
      nameEn: a.nameEn || a.code,
    }));
  }

  @Get('categories')
  @HttpCode(200)
  @ApiOperation({
    summary: 'Listar todas las categorías',
    description: 'Devuelve la lista completa de categorías disponibles',
  })
  @ApiOkResponse({
    description: 'Lista de categorías',
    type: CategoryResponseDto,
    isArray: true,
  })
  async getCategories(): Promise<CategoryResponseDto[]> {
    const categories = await this.categoryRepository.find({
      where: { isActive: true },
      order: { id: 'ASC' },
    });

    return categories.map((c) => ({
      id: c.id,
      code: c.code,
      nameEs: c.nameEs || c.code,
      nameEn: c.nameEn || c.code,
    }));
  }

  @Get('rescue-menus')
  @HttpCode(200)
  @ApiOperation({
    summary: 'Listar menús de rescate para fidelidad',
    description: 'Devuelve los menús disponibles para canje por fidelidad (10 compras)',
  })
  @ApiOkResponse({
    description: 'Lista de menús de rescate activos',
    isArray: true,
  })
  async getRescueMenus(): Promise<any[]> {
    const menus = await this.rescueMenuRepository.find({
      where: { isActive: true },
      relations: [
        'drink',
        'drink.allergens',
        'drink.images',
        'starter',
        'starter.allergens',
        'starter.images',
        'main',
        'main.allergens',
        'main.images',
        'dessert',
        'dessert.allergens',
        'dessert.images',
      ],
      order: { id: 'ASC' },
    });
const baseUrl = this.configService.get<string>('MINIO_PUBLIC_URL') || 'http://localhost:9000';

    return menus.map((menu) => {
      // Mapear producto con alérgenos e imágenes
      const mapProduct = (product: any) => {
        if (!product) return null;
        
        // Filtrar alérgenos activos (contains o may_contain)
        const productAllergens = product.allergens
          ?.filter((pa: any) => pa.isActive && (pa.contains || pa.mayContain))
          .map((pa: any) => pa.allergenCode)
          .filter((code: string) => code != null) || [];
        
        // Construir URLs completas de imágenes
        const productImages = product.images
          ?.filter((img: any) => img.isActive)
          .map((img: any) => `${baseUrl}${img.path}`) || [];
        
        return {
          id: product.id,
          nameEs: product.nameEs,
          nameEn: product.nameEn,
          allergens: productAllergens,
          images: productImages,
        };
      };

      // Recopilar todos los alérgenos del menú
      const allAllergens = new Set<string>();
      [menu.drink, menu.starter, menu.main, menu.dessert].forEach((product) => {
        if (product?.allergens) {
          product.allergens
            .filter((pa: any) => pa.isActive && (pa.contains || pa.mayContain))
            .forEach((pa: any) => {
              if (pa.allergenCode) {
                allAllergens.add(pa.allergenCode);
              }
            });
        }
      });

      return {
        id: menu.id,
        uuid: menu.uuid,
        nameEs: menu.nameEs,
        nameEn: menu.nameEn,
        descriptionEs: menu.descriptionEs,
        descriptionEn: menu.descriptionEn,
        price: parseFloat(menu.price.toString()),
        currency: menu.currency,
        isVegan: menu.isVegan,
        isActive: menu.isActive,
        allergens: Array.from(allAllergens),
        drink: mapProduct(menu.drink),
        starter: mapProduct(menu.starter),
        main: mapProduct(menu.main),
        dessert: mapProduct(menu.dessert),
      };
    });
  }
}
