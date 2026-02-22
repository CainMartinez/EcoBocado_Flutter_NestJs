import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { OrderOrmEntity } from '../../../orders/infrastructure/typeorm/entities-orm/order.orm-entity';

/**
 * Gestiona las transiciones de estado para pedidos de tipo pickup del restaurante:
 * - confirmed → prepared: La cocina ha preparado el pedido
 * - prepared → completed: El cliente ha recogido el pedido (verificado con QR)
 */
@Injectable()
export class UpdateRestaurantOrderStatusUseCase {
  constructor(
    @InjectRepository(OrderOrmEntity)
    private readonly orderRepo: Repository<OrderOrmEntity>,
  ) {}

  async execute(orderId: number, newStatus: string): Promise<void> {
    const order = await this.orderRepo.findOne({ where: { id: orderId, isActive: true } });

    if (!order) {
      throw new NotFoundException(`Pedido #${orderId} no encontrado`);
    }

    if (order.deliveryType !== 'pickup') {
      throw new BadRequestException('Solo se pueden gestionar pedidos de tipo pickup');
    }

    // Validar transiciones permitidas
    const allowedTransitions: Record<string, string[]> = {
      confirmed: ['prepared'],
      prepared: ['completed'],
    };

    const allowedNext = allowedTransitions[order.status];
    if (!allowedNext || !allowedNext.includes(newStatus)) {
      throw new BadRequestException(
        `Transición no permitida: ${order.status} → ${newStatus}`,
      );
    }

    // Actualizar estado
    await this.orderRepo.update(orderId, { status: newStatus });

    // Registrar timestamp de completado
    if (newStatus === 'completed') {
      await this.orderRepo.update(orderId, { completedAt: new Date() });
    }
  }
}
