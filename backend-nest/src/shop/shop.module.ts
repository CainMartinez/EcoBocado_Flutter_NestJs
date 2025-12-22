import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProductsController } from './presentation/controllers/product.controller';
import { IProductRepository } from './domain/repositories/product.repository';
import { ProductOrmEntity } from './infrastructure/typeorm/entities-orm/product.orm-entity';
import { CategoryOrmEntity } from './infrastructure/typeorm/entities-orm/category.orm-entity';
import { ProductTypeOrmRepository } from './infrastructure/typeorm/repositories/product.typeorm.repository';
import { AllergenOrmEntity } from './infrastructure/typeorm/entities-orm/allergen.orm-entity';
import { RescueMenuOrmEntity } from './infrastructure/typeorm/entities-orm/rescue-menu.orm-entity';
import { ProductAllergenOrmEntity } from './infrastructure/typeorm/entities-orm/product-allergen.orm-entity';
import { QueryCatalogUseCase } from './application/use_cases/query-catalog.usecase';
import { CatalogAssembler } from './presentation/assemblers/catalog.assembler';
import { IRescueMenuRepository } from './domain/repositories/rescue-menu.repository';
import { RescueMenuTypeOrmRepository } from './infrastructure/typeorm/repositories/rescue-menu.typeorm.repository';
import { ImageOrmEntity } from '../media/infrastructure/typeorm/entities-orm/image.orm-entity';
import { ProfileModule } from '../profile/profile.module';
// import { SeedOnBootProvider } from './../db/seed-on-boot.provider';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      ProductOrmEntity,
      CategoryOrmEntity,
      AllergenOrmEntity,
      RescueMenuOrmEntity,
      ProductAllergenOrmEntity,
      ImageOrmEntity,
    ]),
    ProfileModule, // Importar ProfileModule para acceder a USER_ALLERGEN_REPOSITORY_TOKEN
  ],
  controllers: [ProductsController],
  providers: [
    CatalogAssembler,
    QueryCatalogUseCase,
    ProductTypeOrmRepository,
    RescueMenuTypeOrmRepository,
    // SeedOnBootProvider,
    {
      provide: IProductRepository,
      useExisting: ProductTypeOrmRepository,
    },
    {
      provide: IRescueMenuRepository,
      useExisting: RescueMenuTypeOrmRepository,
    },
  ],
  exports: [QueryCatalogUseCase],
})
export class ShopModule {}
