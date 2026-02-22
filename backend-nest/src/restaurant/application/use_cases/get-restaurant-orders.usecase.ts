import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { OrderOrmEntity } from '../../../orders/infrastructure/typeorm/entities-orm/order.orm-entity';
import { OrderItemOrmEntity } from '../../../orders/infrastructure/typeorm/entities-orm/order-item.orm-entity';

@Injectable()
export class GetRestaurantOrdersUseCase {
  constructor(
    @InjectRepository(OrderOrmEntity)
    private readonly orderRepo: Repository<OrderOrmEntity>,
    @InjectRepository(OrderItemOrmEntity)
    private readonly orderItemRepo: Repository<OrderItemOrmEntity>,
  ) {}

  /**
   * Obtiene los pedidos de tipo pickup del restaurante.
   * Filtra por estados relevantes: confirmed, prepared, completed.
   */
  async execute(): Promise<any[]> {
    const orders = await this.orderRepo.find({
      where: {
        deliveryType: 'pickup',
        isActive: true,
        status: In(['confirmed', 'prepared', 'delivered', 'completed']),
      },
      order: { createdAt: 'DESC' },
    });

    const result: any[] = [];

    for (const orderOrm of orders) {
      const items = await this.orderItemRepo.find({
        where: { orderId: orderOrm.id, isActive: true },
        relations: ['product', 'rescueMenu'],
      });

      result.push({
        id: orderOrm.id,
        uuid: orderOrm.uuid,
        userId: orderOrm.userId,
        status: orderOrm.status,
        deliveryType: orderOrm.deliveryType,
        pickupSlotId: orderOrm.pickupSlotId,
        subtotal: orderOrm.subtotal,
        total: orderOrm.total,
        currency: orderOrm.currency,
        notes: orderOrm.notes,
        createdAt: orderOrm.createdAt,
        updatedAt: orderOrm.updatedAt,
        items: items.map((item) => ({
          id: item.id,
          itemType: item.itemType,
          productId: item.productId,
          rescueMenuId: item.rescueMenuId,
          quantity: item.quantity,
          unitPrice: item.unitPrice,
          lineTotal: item.lineTotal,
          itemName: item.itemType === 'product' ? item.product?.nameEs : item.rescueMenu?.nameEs,
          createdAt: item.createdAt,
          updatedAt: item.updatedAt,
        })),
      });
    }

    return result;
  }
}
