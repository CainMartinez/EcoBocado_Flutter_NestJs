import { Inject, Injectable, NotFoundException } from '@nestjs/common';
import * as OrderRepo from '../../domain/repositories/order.repository.interface';
import { OrderResponseDto } from '../dto/response/order.response.dto';

@Injectable()
export class GetOrderByIdUseCase {
  constructor(
    @Inject(OrderRepo.ORDER_REPOSITORY_TOKEN)
    private readonly orderRepository: OrderRepo.IOrderRepository,
  ) {}

  async execute(orderId: number): Promise<OrderResponseDto> {
    const result = await this.orderRepository.findById(orderId);

    if (!result) {
      throw new NotFoundException(`Order with id ${orderId} not found`);
    }

    const { order, items } = result;

    return {
      id: order.id,
      uuid: order.uuid,
      userId: order.userId,
      status: order.status,
      deliveryType: order.deliveryType,
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
    };
  }
}
