import { DeliveryDriver } from '../entities/delivery-driver.entity';

export abstract class IDeliveryDriverRepository {
  abstract findById(id: number): Promise<DeliveryDriver | null>;
  abstract findByEmail(email: string): Promise<DeliveryDriver | null>;
  abstract findByUuid(uuid: string): Promise<DeliveryDriver | null>;
  abstract save(driver: DeliveryDriver): Promise<DeliveryDriver>;
  abstract create(driver: Partial<DeliveryDriver>): Promise<DeliveryDriver>;
  abstract update(id: number, data: Partial<DeliveryDriver>): Promise<DeliveryDriver>;
}
