import { Injectable, OnApplicationBootstrap } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { CategoryOrmEntity } from '../shop/infrastructure/typeorm/entities-orm/category.orm-entity';
import { ProductOrmEntity } from '../shop/infrastructure/typeorm/entities-orm/product.orm-entity';
import { AdminsOrmEntity } from 'src/auth/infrastructure/typeorm/entities-orm/admins.orm-entity';
import * as argon2 from 'argon2';

// UUIDs a mano para que no cree nuevos productos con distinto uuid en cada arranque
const PRODUCT_UUIDS = {
  agua50: '11111111-1111-1111-1111-111111111111',
  wrapVegan: '22222222-2222-2222-2222-222222222222',
  burgerZW: '33333333-3333-3333-3333-333333333333',
  brownieIce: '44444444-4444-4444-4444-444444444444',
};

@Injectable()
export class SeedOnBootProvider implements OnApplicationBootstrap {

  constructor(private readonly ds: DataSource) {}

  async onApplicationBootstrap(): Promise<void> {
    // Espera robusta a que TypeORM esté listo (y haya creado el esquema si DB_SYNC=true)
    let retries = 30;
    while (!this.ds.isInitialized && retries > 0) {
      await new Promise((r) => setTimeout(r, 1000));
      retries--;
    }
    if (!this.ds.isInitialized) {
      return;
    }

    await this.ds.transaction(async (em) => {
      const categoryRepo = em.getRepository(CategoryOrmEntity);
      const productRepo  = em.getRepository(ProductOrmEntity);
      const adminRepo = em.getRepository(AdminsOrmEntity);

      const adminEmail = 'cain@gmail.com';
      const adminPassword = 'Password1!';
      const existingAdmin = await adminRepo.findOne({ where: { email: adminEmail } });

      if (!existingAdmin) {
        const passwordHash = await argon2.hash(adminPassword);
        const admin = adminRepo.create({
          uuid: null,
          email: adminEmail,
          name: 'Cain',
          passwordHash,
          avatarUrl: `https://i.pravatar.cc/200?u=${encodeURIComponent(adminEmail)}`,
          isActive: true,
          createdAt: new Date(),
          updatedAt: new Date(),
        });
        await adminRepo.save(admin);
      } else {
      }
      // Categorías base (para FK de productos), los crea si no existen
      const cats = [
        { code: 'bebidas',     nameEs: 'Bebidas',     nameEn: 'Drinks' },
        { code: 'entrantes',   nameEs: 'Entrantes',   nameEn: 'Starters' },
        { code: 'principales', nameEs: 'Principales', nameEn: 'Mains' },
        { code: 'postres',     nameEs: 'Postres',     nameEn: 'Desserts' },
      ];
      await categoryRepo.upsert(
        cats.map((c) => ({
          uuid: null,
          code: c.code,
          nameEs: c.nameEs,
          nameEn: c.nameEn,
          isActive: true,
          createdAt: new Date(),
          updatedAt: new Date(),
        })),
        ['code'],
      );

      const bebidas     = await categoryRepo.findOne({ where: { code: 'bebidas' } });
      const entrantes   = await categoryRepo.findOne({ where: { code: 'entrantes' } });
      const principales = await categoryRepo.findOne({ where: { code: 'principales' } });
      const postres     = await categoryRepo.findOne({ where: { code: 'postres' } });

      // Productos zero-waste (upsert por uuid estable)
      await productRepo.upsert(
        [
          {
            uuid: PRODUCT_UUIDS.agua50,
            nameEs: 'Agua mineral 50cl',
            nameEn: 'Mineral Water 50cl',
            descriptionEs: 'Agua embotellada en envase reciclable.',
            descriptionEn: 'Bottled water in recyclable packaging.',
            price: 1.2, currency: 'EUR',
            isVegan: true, isActive: true,
            category: bebidas!,
            createdAt: new Date(), updatedAt: new Date(),
          },
          {
            uuid: PRODUCT_UUIDS.wrapVegan,
            nameEs: 'Wrap vegetal',
            nameEn: 'Vegan wrap',
            descriptionEs: 'Tortilla con verduras de temporada.',
            descriptionEn: 'Tortilla wrap with seasonal vegetables.',
            price: 4.5, currency: 'EUR',
            isVegan: true, isActive: true,
            category: entrantes!,
            createdAt: new Date(), updatedAt: new Date(),
          },
          {
            uuid: PRODUCT_UUIDS.burgerZW,
            nameEs: 'Hamburguesa zero waste',
            nameEn: 'Zero waste burger',
            descriptionEs: 'Ingredientes locales de aprovechamiento.',
            descriptionEn: 'Locally recovered ingredients.',
            price: 8.9, currency: 'EUR',
            isVegan: false, isActive: true,
            category: principales!,
            createdAt: new Date(), updatedAt: new Date(),
          },
          {
            uuid: PRODUCT_UUIDS.brownieIce,
            nameEs: 'Brownie con helado',
            nameEn: 'Brownie with ice cream',
            descriptionEs: 'Excedente de cacao y leche vegetal.',
            descriptionEn: 'Surplus cocoa and plant milk.',
            price: 3.8, currency: 'EUR',
            isVegan: false, isActive: true,
            category: postres!,
            createdAt: new Date(), updatedAt: new Date(),
          },
        ],
        ['uuid'],
      );
    });
    // Mensaje para el log de docker
  }
}