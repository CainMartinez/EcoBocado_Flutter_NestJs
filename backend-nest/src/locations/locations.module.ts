import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { VenueOrmEntity } from './infrastructure/typeorm/entities-orm/venue.orm-entity';
import { OpeningHourOrmEntity } from './infrastructure/typeorm/entities-orm/opening_hour.orm-entity';
import { PickupSlotOrmEntity } from './infrastructure/typeorm/entities-orm/pickup-slot.orm-entity';
import { PICKUP_SLOT_REPOSITORY_TOKEN } from './domain/repositories/pickup-slot.repository.interface';
import { TypeOrmPickupSlotRepository } from './infrastructure/typeorm/repositories/typeorm-pickup-slot.repository';
import { GetAvailablePickupSlotsUseCase } from './application/use_cases/get-available-pickup-slots.use-case';
import { PickupSlotsController } from './presentation/controllers/pickup-slots.controller';

@Module({
  imports: [TypeOrmModule.forFeature([OpeningHourOrmEntity, VenueOrmEntity, PickupSlotOrmEntity])],
  controllers: [PickupSlotsController],
  providers: [
    {
      provide: PICKUP_SLOT_REPOSITORY_TOKEN,
      useClass: TypeOrmPickupSlotRepository,
    },
    GetAvailablePickupSlotsUseCase,
  ],
  exports: [PICKUP_SLOT_REPOSITORY_TOKEN],
})
export class LocationsModule {}
