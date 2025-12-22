import { Inject, Injectable } from '@nestjs/common';
import * as PickupSlotRepo from '../../domain/repositories/pickup-slot.repository.interface';
import { PickupSlotResponseDto } from '../dto/response/pickup-slot.response.dto';

@Injectable()
export class GetAvailablePickupSlotsUseCase {
  constructor(
    @Inject(PickupSlotRepo.PICKUP_SLOT_REPOSITORY_TOKEN)
    private readonly pickupSlotRepository: PickupSlotRepo.IPickupSlotRepository,
  ) {}

  async execute(startDate?: string, endDate?: string): Promise<PickupSlotResponseDto[]> {
    const today = new Date().toISOString().split('T')[0];
    const start = startDate || today;
    const end = endDate || this.getDatePlusDays(today, 7); // 7 días por defecto

    const slots = await this.pickupSlotRepository.findAvailableByDateRange(start, end);

    return slots.map((slot) => ({
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

  private getDatePlusDays(dateStr: string, days: number): string {
    const date = new Date(dateStr);
    date.setDate(date.getDate() + days);
    return date.toISOString().split('T')[0];
  }
}
