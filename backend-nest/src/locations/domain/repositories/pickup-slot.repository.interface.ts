import { PickupSlot } from '../entities/pickup-slot.entity';

export const PICKUP_SLOT_REPOSITORY_TOKEN = Symbol('PICKUP_SLOT_REPOSITORY');

export interface IPickupSlotRepository {
  /**
   * Obtiene los slots disponibles para una fecha específica
   */
  findAvailableByDate(date: string): Promise<PickupSlot[]>;

  /**
   * Obtiene los slots disponibles en un rango de fechas
   */
  findAvailableByDateRange(startDate: string, endDate: string): Promise<PickupSlot[]>;

  /**
   * Obtiene un slot por ID
   */
  findById(id: number): Promise<PickupSlot | null>;
}
