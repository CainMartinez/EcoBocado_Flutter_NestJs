import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { JwtModule } from '@nestjs/jwt';
import { VenueOrmEntity } from '../locations/infrastructure/typeorm/entities-orm/venue.orm-entity';
import { OrderOrmEntity } from '../orders/infrastructure/typeorm/entities-orm/order.orm-entity';
import { OrderItemOrmEntity } from '../orders/infrastructure/typeorm/entities-orm/order-item.orm-entity';
import { VenueAuthTypeOrmRepository } from './infrastructure/typeorm/repositories/venue-auth.typeorm.repository';
import { IVenueAuthRepository } from './domain/repositories/venue-auth.repository';
import { RestaurantJwtTokenService } from './infrastructure/token/restaurant-jwt-token.service';
import { RestaurantJwtStrategy } from './infrastructure/strategies/restaurant-jwt.strategy';
import { RestaurantLoginUseCase } from './application/use_cases/restaurant-login.usecase';
import { GetRestaurantProfileUseCase } from './application/use_cases/get-restaurant-profile.usecase';
import { UploadRestaurantAvatarUseCase } from './application/use_cases/upload-restaurant-avatar.usecase';
import { GetRestaurantOrdersUseCase } from './application/use_cases/get-restaurant-orders.usecase';
import { GetRestaurantStatsUseCase } from './application/use_cases/get-restaurant-stats.usecase';
import { UpdateRestaurantOrderStatusUseCase } from './application/use_cases/update-restaurant-order-status.usecase';
import { RestaurantLoginController } from './presentation/controllers/restaurant-login.controller';
import { RestaurantProfileController } from './presentation/controllers/restaurant-profile.controller';
import { RestaurantOrdersController } from './presentation/controllers/restaurant-orders.controller';
import { VenuePublicAssembler } from './presentation/assemblers/venue-public.assembler';
import { AuthModule } from '../auth/auth.module';
import { MediaModule } from '../media/media.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([VenueOrmEntity, OrderOrmEntity, OrderItemOrmEntity]),
    JwtModule.register({
      secret: process.env.JWT_SECRET ?? 'dev-secret-change-me',
      signOptions: {
        issuer: process.env.JWT_ISSUER ?? 'zero-waste-api',
        audience: process.env.JWT_AUDIENCE ?? 'zero-waste-clients',
      },
    }),
    AuthModule,
    MediaModule,
  ],
  controllers: [
    RestaurantLoginController,
    RestaurantProfileController,
    RestaurantOrdersController,
  ],
  providers: [
    VenueAuthTypeOrmRepository,
    RestaurantJwtTokenService,
    RestaurantJwtStrategy,
    RestaurantLoginUseCase,
    GetRestaurantProfileUseCase,
    UploadRestaurantAvatarUseCase,
    GetRestaurantOrdersUseCase,
    GetRestaurantStatsUseCase,
    UpdateRestaurantOrderStatusUseCase,
    VenuePublicAssembler,
    {
      provide: IVenueAuthRepository,
      useExisting: VenueAuthTypeOrmRepository,
    },
  ],
})
export class RestaurantModule {}
