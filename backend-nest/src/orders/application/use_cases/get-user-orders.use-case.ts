import { Inject, Injectable } from '@nestjs/common';
import * as OrderRepo from '../../domain/repositories/order.repository.interface';
import * as DeliveryRepo from '../../../delivery/domain/repositories/delivery.repository.interface';
import { OrderResponseDto } from '../dto/response/order.response.dto';

@Injectable()
export class GetUserOrdersUseCase {
  constructor(
    @Inject(OrderRepo.ORDER_REPOSITORY_TOKEN)
    private readonly orderRepository: OrderRepo.IOrderRepository,
    @Inject(DeliveryRepo.DELIVERY_REPOSITORY_TOKEN)
    private readonly deliveryRepository: DeliveryRepo.IDeliveryRepository,
  ) {}

  async execute(userId: number): Promise<OrderResponseDto[]> {
    const results = await this.orderRepository.findByUserId(userId);

    const ordersWithDelivery = await Promise.all(
      results.map(async ({ order, items }) => {
        let deliveryInfo: {
          addressLine1: string;
          addressLine2: string | null;
          city: string;
          postalCode: string;
          phone: string | null;
        } | null = null;

        // Si el pedido es de tipo delivery, obtener la información de entrega
        if (order.deliveryType === 'delivery') {
          const delivery = await this.deliveryRepository.findByOrderId(order.id);
          if (delivery) {
            deliveryInfo = {
              addressLine1: delivery.addressLine1,
              addressLine2: delivery.addressLine2,
              city: delivery.city,
              postalCode: delivery.postalCode,
              phone: delivery.phone,
            };
          }
        }

        return {
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
          delivery: deliveryInfo,
          createdAt: order.createdAt,
          updatedAt: order.updatedAt,
        };
      })
    );

    return ordersWithDelivery;
  }
}
