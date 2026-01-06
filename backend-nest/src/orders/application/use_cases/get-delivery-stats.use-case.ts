import { Inject, Injectable } from '@nestjs/common';
import * as OrderRepo from '../../domain/repositories/order.repository.interface';

export interface DeliveryStats {
  todayPending: number;
  todayInProgress: number;
  todayCompleted: number;
  totalCompleted: number;
  weekCompleted: number;
  monthCompleted: number;
  totalRevenue: number;
}

@Injectable()
export class GetDeliveryStatsUseCase {
  constructor(
    @Inject(OrderRepo.ORDER_REPOSITORY_TOKEN)
    private readonly orderRepository: OrderRepo.IOrderRepository,
  ) {}

  async execute(userId: number): Promise<DeliveryStats> {
    const allOrders = await this.orderRepository.findByUserId(userId);
    
    const now = new Date();
    const todayStart = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const weekStart = new Date(now);
    weekStart.setDate(now.getDate() - 7);
    const monthStart = new Date(now.getFullYear(), now.getMonth(), 1);

    const stats: DeliveryStats = {
      todayPending: 0,
      todayInProgress: 0,
      todayCompleted: 0,
      totalCompleted: 0,
      weekCompleted: 0,
      monthCompleted: 0,
      totalRevenue: 0,
    };

    for (const { order } of allOrders) {
      const orderDate = new Date(order.createdAt);

      // Total completados y revenue
      if (order.status === 'completed') {
        stats.totalCompleted++;
        stats.totalRevenue += order.total;

        // Completados esta semana
        if (orderDate >= weekStart) {
          stats.weekCompleted++;
        }

        // Completados este mes
        if (orderDate >= monthStart) {
          stats.monthCompleted++;
        }

        // Completados hoy
        if (orderDate >= todayStart) {
          stats.todayCompleted++;
        }
      }

      // Pedidos de hoy por estado
      if (orderDate >= todayStart) {
        if (order.status === 'confirmed') {
          stats.todayPending++;
        } else if (order.status === 'delivered') {
          stats.todayInProgress++;
        }
      }
    }

    return stats;
  }
}
