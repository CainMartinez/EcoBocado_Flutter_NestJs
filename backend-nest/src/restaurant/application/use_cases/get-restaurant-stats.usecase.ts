import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { OrderOrmEntity } from '../../../orders/infrastructure/typeorm/entities-orm/order.orm-entity';

export interface RestaurantStats {
  todayPending: number;      // Pedidos pickup confirmados hoy (pendientes de preparar)
  todayPrepared: number;     // Pedidos pickup preparados hoy (listos para recoger)
  todayCompleted: number;    // Pedidos pickup completados hoy
  weekCompleted: number;     // Pedidos pickup completados esta semana
  monthCompleted: number;    // Pedidos pickup completados este mes
  totalCompleted: number;    // Total histórico de pickups completados
  totalRevenue: number;      // Ingresos totales de pickups
}

@Injectable()
export class GetRestaurantStatsUseCase {
  constructor(
    @InjectRepository(OrderOrmEntity)
    private readonly orderRepo: Repository<OrderOrmEntity>,
  ) {}

  async execute(): Promise<RestaurantStats> {
    const allOrders = await this.orderRepo.find({
      where: {
        deliveryType: 'pickup',
        isActive: true,
      },
    });

    const now = new Date();
    const todayStart = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const weekStart = new Date(now);
    weekStart.setDate(now.getDate() - 7);
    const monthStart = new Date(now.getFullYear(), now.getMonth(), 1);

    const stats: RestaurantStats = {
      todayPending: 0,
      todayPrepared: 0,
      todayCompleted: 0,
      weekCompleted: 0,
      monthCompleted: 0,
      totalCompleted: 0,
      totalRevenue: 0,
    };

    for (const order of allOrders) {
      const orderDate = new Date(order.createdAt);

      if (order.status === 'completed') {
        stats.totalCompleted++;
        stats.totalRevenue += Number(order.total);

        if (orderDate >= weekStart) stats.weekCompleted++;
        if (orderDate >= monthStart) stats.monthCompleted++;
        if (orderDate >= todayStart) stats.todayCompleted++;
      }

      if (orderDate >= todayStart) {
        if (order.status === 'confirmed') stats.todayPending++;
        if (order.status === 'prepared') stats.todayPrepared++;
      }
    }

    return stats;
  }
}
