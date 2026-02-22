import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule } from '@nestjs/config';
import { ShopModule } from './shop/shop.module';
import { OrdersModule } from './orders/orders.module';
import { BillingModule } from './billing/billing.module';
import { LoyaltyModule } from './loyalty/loyalty.module';
import { AuthModule } from './auth/auth.module';
import { LocationsModule } from './locations/locations.module';
import { ThrottlerModule } from '@nestjs/throttler/dist/throttler.module';
import { ProfileModule } from './profile/profile.module';
import { MediaModule } from './media/media.module';
import { AdminModule } from './admin/admin.module';
import { DeliveryModule } from './delivery/delivery.module';
import { PaymentModule } from './payment/payment.module';
import { RestaurantModule } from './restaurant/restaurant.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    TypeOrmModule.forRoot({
      type: 'mysql',
      host: process.env.DB_HOST ?? process.env.MYSQL_HOST ?? 'localhost',
      port: parseInt(process.env.DB_PORT ?? process.env.MYSQL_PORT ?? '3306', 10),
      username: process.env.DB_USER ?? process.env.MYSQL_USER ?? 'root',
      password: process.env.DB_PASSWORD ?? process.env.MYSQL_PASSWORD ?? '',
      database: process.env.DB_NAME ?? process.env.MYSQL_DATABASE ?? 'zero_waste_db',
      entities: [__dirname + '/**/*.orm-entity{.ts,.js}'],
      synchronize: true,
      autoLoadEntities: true,
    }),
    ThrottlerModule.forRoot([{
      ttl: 60,   // ventana de 60 segundos
      limit: 20, // máximo 20 peticiones por IP
    }]),
    ShopModule,
    OrdersModule,
    BillingModule,
    LoyaltyModule,
    AuthModule,
    LocationsModule,
    ProfileModule,
    MediaModule,
    AdminModule,
    DeliveryModule,
    PaymentModule,
    RestaurantModule,
  ],
})
export class AppModule {}
