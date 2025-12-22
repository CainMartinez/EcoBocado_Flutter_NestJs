import { Inject, Injectable } from '@nestjs/common';
import * as OrderRepo from '../../domain/repositories/order.repository.interface';
import { OrderResponseDto } from '../dto/response/order.response.dto';

@Injectable()
export class GetUserOrdersUseCase {
  constructor(
    @Inject(OrderRepo.ORDER_REPOSITORY_TOKEN)
    private readonly orderRepository: OrderRepo.IOrderRepository,
  ) {}

  async execute(userId: number): Promise<OrderResponseDto[]> {
    const results = await this.orderRepository.findByUserId(userId);

    return results.map(({ order, items }) => ({
      id: order.id,
      uuid: order.uuid,
      userId: order.userId,
      status: order.status,
      pickupSlotId: order.pickupSlotId,
      paymentIntentId: order.paymentIntentId,
      subtotal: order.subtotal,
      total: order.total,
      currency: order.currency,
      notes: order.notes,
      items: items.map((item) => ({
        id: item.id,
        itemType: item.itemType,
        productId: item.productId,
        rescueMenuId: item.rescueMenuId,
        quantity: item.quantity,
        unitPrice: item.unitPrice,
        lineTotal: item.lineTotal,
        itemName: item.itemName,
        createdAt: item.createdAt,
        updatedAt: item.updatedAt,
      })),
      createdAt: order.createdAt,
      updatedAt: order.updatedAt,
    }));
  }
}
