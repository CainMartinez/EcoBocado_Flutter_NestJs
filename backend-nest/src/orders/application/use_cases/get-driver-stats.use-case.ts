import { Inject, Injectable } from '@nestjs/common';
import * as OrderRepo from '../../domain/repositories/order.repository.interface';

export interface DriverStat {
  driverId: number;
  driverName: string;
  completedOrders: number;
  averageDeliveryTime: number; // en minutos
}

@Injectable()
export class GetDriverStatsUseCase {
  constructor(
    @Inject(OrderRepo.ORDER_REPOSITORY_TOKEN)
    private readonly orderRepository: OrderRepo.IOrderRepository,
  ) {}

  async execute(): Promise<DriverStat[]> {
    return await this.orderRepository.getDriverStats();
  }
}
