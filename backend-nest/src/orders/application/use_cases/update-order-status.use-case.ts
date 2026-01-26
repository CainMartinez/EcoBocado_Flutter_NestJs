import { Inject, Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import * as OrderRepo from '../../domain/repositories/order.repository.interface';
import { OrderStatus } from '../../domain/entities/order.entity';

@Injectable()
export class UpdateOrderStatusUseCase {
  constructor(
    @Inject(OrderRepo.ORDER_REPOSITORY_TOKEN)
    private readonly orderRepository: OrderRepo.IOrderRepository,
  ) {}

  async execute(orderId: number, newStatus: OrderStatus, driverId?: number): Promise<void> {
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

    // Si se intenta marcar como "completed", validar que el repartidor sea el asignado
    if (newStatus === 'completed' && driverId) {
      if (order.driverId === null) {
        throw new BadRequestException('Este pedido no tiene un repartidor asignado');
      }
      
      if (order.driverId !== driverId) {
        throw new BadRequestException(
          'No puedes completar un pedido que no está asignado a ti. ' +
          `Pedido asignado a repartidor ID: ${order.driverId}, tu ID: ${driverId}`
        );
      }
    }

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

    // Si el estado cambia a "delivered" y se proporciona un driverId, actualizar ambos
    if (newStatus === 'delivered' && driverId) {
      await this.orderRepository.updateStatusAndDriver(orderId, newStatus, driverId);
      // Guardar timestamp de cuando se acepta el pedido
      await this.orderRepository.updateDeliveredAt(orderId, new Date());
    } else if (newStatus === 'completed') {
      // Guardar timestamp de cuando se completa el pedido
      await this.orderRepository.updateCompletedAt(orderId, new Date());
      await this.orderRepository.updateStatus(orderId, newStatus);
    } else {
      // Actualizar solo el estado
      await this.orderRepository.updateStatus(orderId, newStatus);
    }
  }
}
