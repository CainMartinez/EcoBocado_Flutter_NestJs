import { Injectable } from '@nestjs/common';
import { IDeliveryDriverRepository } from '../../domain/repositories/delivery-driver.repository';
import { DeliveryDriverNotFoundException } from '../../domain/exceptions/delivery-driver-not-found.exception';

@Injectable()
export class GetDeliveryProfileUseCase {
  constructor(private readonly driverRepo: IDeliveryDriverRepository) {}

  async execute(driverId: number) {
    const driver = await this.driverRepo.findById(driverId);
    if (!driver) {
      throw new DeliveryDriverNotFoundException(driverId);
    }
    return driver;
  }
}
