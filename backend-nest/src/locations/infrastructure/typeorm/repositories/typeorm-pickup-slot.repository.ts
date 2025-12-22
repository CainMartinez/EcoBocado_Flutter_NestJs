import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, MoreThanOrEqual, LessThanOrEqual, Between } from 'typeorm';
import { PickupSlotOrmEntity } from '../entities-orm/pickup-slot.orm-entity';
import { IPickupSlotRepository } from '../../../domain/repositories/pickup-slot.repository.interface';
import { PickupSlot } from '../../../domain/entities/pickup-slot.entity';

@Injectable()
export class TypeOrmPickupSlotRepository implements IPickupSlotRepository {
  constructor(
    @InjectRepository(PickupSlotOrmEntity)
    private readonly pickupSlotRepo: Repository<PickupSlotOrmEntity>,
  ) {}

  async findAvailableByDate(date: string): Promise<PickupSlot[]> {
    const slotsOrm = await this.pickupSlotRepo.find({
      where: {
        slotDate: date,
        isActive: true,
      },
      order: {
        startTime: 'ASC',
      },
    });

    return slotsOrm
      .filter((slot) => slot.bookedCount < slot.capacity)
      .map((slot) => PickupSlot.fromPrimitives({
        id: slot.id,
        venueId: slot.venueId,
        slotDate: slot.slotDate,
        startTime: slot.startTime,
        endTime: slot.endTime,
        capacity: slot.capacity,
        bookedCount: slot.bookedCount,
        isActive: slot.isActive,
        createdAt: slot.createdAt,
        updatedAt: slot.updatedAt,
      }));
  }

  async findAvailableByDateRange(startDate: string, endDate: string): Promise<PickupSlot[]> {
    const slotsOrm = await this.pickupSlotRepo.find({
      where: {
        slotDate: Between(startDate, endDate),
        isActive: true,
      },
      order: {
        slotDate: 'ASC',
        startTime: 'ASC',
      },
    });

    return slotsOrm
      .filter((slot) => slot.bookedCount < slot.capacity)
      .map((slot) => PickupSlot.fromPrimitives({
        id: slot.id,
        venueId: slot.venueId,
        slotDate: slot.slotDate,
        startTime: slot.startTime,
        endTime: slot.endTime,
        capacity: slot.capacity,
        bookedCount: slot.bookedCount,
        isActive: slot.isActive,
        createdAt: slot.createdAt,
        updatedAt: slot.updatedAt,
      }));
  }

  async findById(id: number): Promise<PickupSlot | null> {
    const slotOrm = await this.pickupSlotRepo.findOne({
      where: { id, isActive: true },
    });

    if (!slotOrm) return null;

    return PickupSlot.fromPrimitives({
      id: slotOrm.id,
      venueId: slotOrm.venueId,
      slotDate: slotOrm.slotDate,
      startTime: slotOrm.startTime,
      endTime: slotOrm.endTime,
      capacity: slotOrm.capacity,
      bookedCount: slotOrm.bookedCount,
      isActive: slotOrm.isActive,
      createdAt: slotOrm.createdAt,
      updatedAt: slotOrm.updatedAt,
    });
  }
}
