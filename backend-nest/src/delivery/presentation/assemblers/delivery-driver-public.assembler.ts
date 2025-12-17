import { Injectable } from '@nestjs/common';
import { DeliveryDriver } from '../../domain/entities/delivery-driver.entity';

@Injectable()
export class DeliveryDriverPublicAssembler {
  toPublic(driver: DeliveryDriver) {
    return {
      id: driver.id,
      uuid: driver.uuid,
      email: driver.email,
      name: driver.name,
      phone: driver.phone,
      avatarUrl: driver.avatarUrl,
      isAvailable: driver.isAvailable,
      vehicleType: driver.vehicleType,
      vehiclePlate: driver.vehiclePlate,
    };
  }
}
