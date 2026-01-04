import { Inject, Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import * as OrderRepo from '../../domain/repositories/order.repository.interface';
import { OrderStatus } from '../../domain/entities/order.entity';

@Injectable()
export class UpdateOrderStatusUseCase {
  constructor(
    @Inject(OrderRepo.ORDER_REPOSITORY_TOKEN)
    private readonly orderRepository: OrderRepo.IOrderRepository,
  ) {}

  async execute(orderId: number, newStatus: OrderStatus): Promise<void> {
    // Validar que el estado es válido
    const validStatuses: OrderStatus[] = [
      'draft',
      'pending_payment',
      'confirmed',
      'prepared',
      'delivered',
      'cancelled',
      'completed',
    ];

    if (!validStatuses.includes(newStatus)) {
      throw new BadRequestException(`Estado inválido: ${newStatus}`);
    }

    // Buscar el pedido
    const result = await this.orderRepository.findById(orderId);
    if (!result) {
      throw new NotFoundException(`Pedido con ID ${orderId} no encontrado`);
    }

    const { order } = result;

    // Validar transiciones de estado permitidas
    const currentStatus = order.status;
    const allowedTransitions: Record<OrderStatus, OrderStatus[]> = {
      draft: ['pending_payment', 'cancelled'],
      pending_payment: ['confirmed', 'cancelled'],
      confirmed: ['prepared', 'delivered', 'cancelled'],
      prepared: ['delivered', 'cancelled'],
      delivered: ['completed', 'cancelled'],
      cancelled: [],
      completed: [],
    };

    const allowed = allowedTransitions[currentStatus];
    if (!allowed.includes(newStatus)) {
      throw new BadRequestException(
        `No se puede cambiar el estado de '${currentStatus}' a '${newStatus}'`,
      );
    }

    // Actualizar el estado
    await this.orderRepository.updateStatus(orderId, newStatus);
  }
}
