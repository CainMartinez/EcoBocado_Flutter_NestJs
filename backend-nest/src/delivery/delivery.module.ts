import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { JwtModule } from '@nestjs/jwt';
import { DeliveryDriverOrmEntity } from './infrastructure/typeorm/entities-orm/delivery-driver.orm-entity';
import { DeliveryDriverTypeOrmRepository } from './infrastructure/typeorm/repositories/delivery-driver.typeorm.repository';
import { IDeliveryDriverRepository } from './domain/repositories/delivery-driver.repository';
import { DeliveryJwtTokenService } from './infrastructure/token/delivery-jwt-token.service';
import { DeliveryJwtStrategy } from './infrastructure/strategies/delivery-jwt.strategy';
import { DeliveryLoginUseCase } from './application/use_cases/delivery-login.usecase';
import { GetDeliveryProfileUseCase } from './application/use_cases/get-delivery-profile.usecase';
import { UpdateAvailabilityUseCase } from './application/use_cases/update-availability.usecase';
import { RegisterDeliveryDriverUseCase } from './application/use_cases/register-delivery-driver.usecase';
import { DeliveryLoginController } from './presentation/controllers/delivery-login.controller';
import { DeliveryProfileController } from './presentation/controllers/delivery-profile.controller';
import { DeliveryRegisterController } from './presentation/controllers/delivery-register.controller';
import { DeliveryDriverPublicAssembler } from './presentation/assemblers/delivery-driver-public.assembler';
import { AuthModule } from '../auth/auth.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([DeliveryDriverOrmEntity]),
    JwtModule.register({
      secret: process.env.JWT_SECRET ?? 'dev-secret-change-me',
      signOptions: {
        issuer: process.env.JWT_ISSUER ?? 'zero-waste-api',
        audience: process.env.JWT_AUDIENCE ?? 'zero-waste-clients',
      },
    }),
    AuthModule, // Para usar PasswordHasherService
  ],
  controllers: [DeliveryLoginController, DeliveryProfileController, DeliveryRegisterController],
  providers: [
    DeliveryDriverTypeOrmRepository,
    DeliveryJwtTokenService,
    DeliveryJwtStrategy,
    DeliveryLoginUseCase,
    GetDeliveryProfileUseCase,
    UpdateAvailabilityUseCase,
    RegisterDeliveryDriverUseCase,
    DeliveryDriverPublicAssembler,
    {
      provide: IDeliveryDriverRepository,
      useExisting: DeliveryDriverTypeOrmRepository,
    },
  ],
  exports: [
    DeliveryJwtTokenService,
    {
      provide: IDeliveryDriverRepository,
      useExisting: DeliveryDriverTypeOrmRepository,
    },
  ],
})
export class DeliveryModule {}
