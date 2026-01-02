import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { OrderOrmEntity } from '../../../orders/infrastructure/typeorm/entities-orm/order.orm-entity';
import { RecentOrderResponseDto } from '../dto/response/recent-order.response.dto';

@Injectable()
export class GetRecentOrdersUseCase {
  constructor(
    @InjectRepository(OrderOrmEntity)
    private readonly orderRepository: Repository<OrderOrmEntity>,
  ) {}

  async execute(limit: number = 10): Promise<RecentOrderResponseDto[]> {
    const orders = await this.orderRepository
      .createQueryBuilder('order')
      .leftJoinAndSelect('order.user', 'user')
      .orderBy('order.created_at', 'DESC')
      .limit(limit)
      .getMany();

    return orders.map((order) => ({
      id: order.id,
      uuid: order.uuid || '',
      customerName: order.user?.name || 'N/A',
      orderType: order.deliveryType,
      status: order.status,
      totalAmount: parseFloat(order.total.toString()),
      createdAt: order.createdAt,
    }));
  }
}
