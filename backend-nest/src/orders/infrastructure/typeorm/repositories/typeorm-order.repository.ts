import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import { OrderOrmEntity } from '../entities-orm/order.orm-entity';
import { OrderItemOrmEntity } from '../entities-orm/order-item.orm-entity';
import { PickupSlotOrmEntity } from '../../../../locations/infrastructure/typeorm/entities-orm/pickup-slot.orm-entity';
import { IOrderRepository } from '../../../domain/repositories/order.repository.interface';
import { Order, DeliveryType } from '../../../domain/entities/order.entity';
import { OrderItem } from '../../../domain/entities/order-item.entity';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class TypeOrmOrderRepository implements IOrderRepository {
  constructor(
    @InjectRepository(OrderOrmEntity)
    private readonly orderRepo: Repository<OrderOrmEntity>,
    @InjectRepository(OrderItemOrmEntity)
    private readonly orderItemRepo: Repository<OrderItemOrmEntity>,
    @InjectRepository(PickupSlotOrmEntity)
    private readonly pickupSlotRepo: Repository<PickupSlotOrmEntity>,
    private readonly dataSource: DataSource,
  ) {}

  async createOrder(
    userId: number,
    items: Array<{
      itemType: 'product' | 'menu';
      itemId: number;
      quantity: number;
      unitPrice: number;
    }>,
    options?: {
      deliveryType?: DeliveryType;
      pickupSlotId?: number;
      // Pickup dinámico (si no hay pickupSlotId)
      pickupDate?: string;
      pickupStartTime?: string;
      pickupEndTime?: string;
      venueId?: number;
      notes?: string;
      paymentIntentId?: string;
    },
  ): Promise<{ order: Order; items: OrderItem[] }> {
    return await this.dataSource.transaction(async (manager) => {
      const deliveryType = options?.deliveryType ?? 'pickup';
      
      // Calcular totales
      const subtotal = items.reduce((acc, item) => acc + item.quantity * item.unitPrice, 0);
      const total = subtotal;

      // Determinar el estado
      const status = options?.paymentIntentId ? 'confirmed' : 'pending_payment';

      let pickupSlotId = options?.pickupSlotId ?? null;

      // Si es pickup y no hay pickupSlotId, crear el slot dinámicamente
      if (deliveryType === 'pickup' && !pickupSlotId && options?.pickupDate && options?.pickupStartTime && options?.pickupEndTime) {
        const venueId = options.venueId ?? 1; // Default venue

        // Buscar si ya existe el slot
        let pickupSlot = await manager.findOne(PickupSlotOrmEntity, {
          where: {
            venueId,
            slotDate: options.pickupDate,
            startTime: options.pickupStartTime,
            endTime: options.pickupEndTime,
          },
        });

        // Si no existe, crearlo
        if (!pickupSlot) {
          const newSlot = manager.create(PickupSlotOrmEntity, {
            venueId,
            slotDate: options.pickupDate,
            startTime: options.pickupStartTime,
            endTime: options.pickupEndTime,
            capacity: 100,
            bookedCount: 0,
            isActive: true,
          });
          pickupSlot = await manager.save(PickupSlotOrmEntity, newSlot);
        }

        // Incrementar el bookedCount
        pickupSlot.bookedCount += 1;
        await manager.save(PickupSlotOrmEntity, pickupSlot);
        
        pickupSlotId = pickupSlot.id;
      }

      // Crear la orden
      const orderOrm = manager.create(OrderOrmEntity, {
        uuid: uuidv4(),
        userId,
        status,
        deliveryType,
        pickupSlotId,
        paymentIntentId: options?.paymentIntentId ?? null,
        subtotal,
        total,
        currency: 'EUR',
        notes: options?.notes ?? null,
        isActive: true,
      });

      const savedOrder = await manager.save(OrderOrmEntity, orderOrm);

      // Crear los items
      const orderItemsOrm = items.map((item) => {
        const lineTotal = item.quantity * item.unitPrice;
        return manager.create(OrderItemOrmEntity, {
          orderId: savedOrder.id,
          itemType: item.itemType === 'menu' ? 'rescue_menu' : 'product',
          productId: item.itemType === 'product' ? item.itemId : null,
          rescueMenuId: item.itemType === 'menu' ? item.itemId : null,
          quantity: item.quantity,
          unitPrice: item.unitPrice,
          lineTotal,
          isActive: true,
        });
      });

      const savedItems = await manager.save(OrderItemOrmEntity, orderItemsOrm);

      // Convertir a entidades de dominio
      const order = Order.fromPrimitives({
        id: savedOrder.id,
        uuid: savedOrder.uuid,
        userId: savedOrder.userId,
        status: savedOrder.status as any,
        deliveryType: savedOrder.deliveryType as any,
        pickupSlotId: savedOrder.pickupSlotId,
        paymentIntentId: savedOrder.paymentIntentId,
        driverId: savedOrder.driverId,
        subtotal: savedOrder.subtotal,
        total: savedOrder.total,
        currency: savedOrder.currency,
        notes: savedOrder.notes,
        isActive: savedOrder.isActive,
        createdAt: savedOrder.createdAt,
        updatedAt: savedOrder.updatedAt,
      });

      const orderItems = savedItems.map((item) =>
        OrderItem.fromPrimitives({
          id: item.id,
          orderId: item.orderId,
          itemType: item.itemType as any,
          productId: item.productId,
          rescueMenuId: item.rescueMenuId,
          quantity: item.quantity,
          unitPrice: item.unitPrice,
          lineTotal: item.lineTotal,
          isActive: item.isActive,
          createdAt: item.createdAt,
          updatedAt: item.updatedAt,
        }),
      );

      return { order, items: orderItems };
    });
  }

  async findById(orderId: number): Promise<{ order: Order; items: OrderItem[] } | null> {
    const orderOrm = await this.orderRepo.findOne({ where: { id: orderId, isActive: true } });
    if (!orderOrm) return null;

    const itemsOrm = await this.orderItemRepo.find({
      where: { orderId, isActive: true },
      relations: ['product', 'rescueMenu'],
    });

    const order = Order.fromPrimitives({
      id: orderOrm.id,
      uuid: orderOrm.uuid,
      userId: orderOrm.userId,
      status: orderOrm.status as any,
      deliveryType: orderOrm.deliveryType as any,
      pickupSlotId: orderOrm.pickupSlotId,
      paymentIntentId: orderOrm.paymentIntentId,
      driverId: orderOrm.driverId,
      subtotal: orderOrm.subtotal,
      total: orderOrm.total,
      currency: orderOrm.currency,
      notes: orderOrm.notes,
      isActive: orderOrm.isActive,
      createdAt: orderOrm.createdAt,
      updatedAt: orderOrm.updatedAt,
    });

    const items = itemsOrm.map((item) => {
      // Obtener el nombre del producto o menú
      const itemName = item.itemType === 'product' 
        ? item.product?.nameEs 
        : item.rescueMenu?.nameEs;

      return OrderItem.fromPrimitives({
        id: item.id,
        orderId: item.orderId,
        itemType: item.itemType as any,
        productId: item.productId,
        rescueMenuId: item.rescueMenuId,
        quantity: item.quantity,
        unitPrice: item.unitPrice,
        lineTotal: item.lineTotal,
        itemName: itemName ?? undefined,
        isActive: item.isActive,
        createdAt: item.createdAt,
        updatedAt: item.updatedAt,
      });
    });

    return { order, items };
  }

  async findByUserId(userId: number): Promise<Array<{ order: Order; items: OrderItem[] }>> {
    const ordersOrm = await this.orderRepo.find({
      where: { userId, isActive: true },
      order: { createdAt: 'DESC' },
    });

    const result: Array<{ order: Order; items: OrderItem[] }> = [];

    for (const orderOrm of ordersOrm) {
      const itemsOrm = await this.orderItemRepo.find({
        where: { orderId: orderOrm.id, isActive: true },
        relations: ['product', 'rescueMenu'],
      });

      const order = Order.fromPrimitives({
        id: orderOrm.id,
        uuid: orderOrm.uuid,
        userId: orderOrm.userId,
        status: orderOrm.status as any,
        deliveryType: orderOrm.deliveryType as any,
        pickupSlotId: orderOrm.pickupSlotId,
        paymentIntentId: orderOrm.paymentIntentId,
        driverId: orderOrm.driverId,
        subtotal: orderOrm.subtotal,
        total: orderOrm.total,
        currency: orderOrm.currency,
        notes: orderOrm.notes,
        isActive: orderOrm.isActive,
        createdAt: orderOrm.createdAt,
        updatedAt: orderOrm.updatedAt,
      });

      const items = itemsOrm.map((item) => {
        // Obtener el nombre del producto o menú
        const itemName = item.itemType === 'product' 
          ? item.product?.nameEs 
          : item.rescueMenu?.nameEs;

        return OrderItem.fromPrimitives({
          id: item.id,
          orderId: item.orderId,
          itemType: item.itemType as any,
          productId: item.productId,
          rescueMenuId: item.rescueMenuId,
          quantity: item.quantity,
          unitPrice: item.unitPrice,
          lineTotal: item.lineTotal,
          itemName: itemName ?? undefined,
          isActive: item.isActive,
          createdAt: item.createdAt,
          updatedAt: item.updatedAt,
        });
      });

      result.push({ order, items });
    }

    return result;
  }

  async updateStatus(orderId: number, status: string): Promise<void> {
    await this.orderRepo.update({ id: orderId }, { status });
  }

  async updateStatusAndDriver(orderId: number, status: string, driverId: number): Promise<void> {
    await this.orderRepo.update({ id: orderId }, { status, driverId });
  }

  async updateDeliveredAt(orderId: number, deliveredAt: Date): Promise<void> {
    await this.orderRepo.update({ id: orderId }, { deliveredAt });
  }

  async updateCompletedAt(orderId: number, completedAt: Date): Promise<void> {
    await this.orderRepo.update({ id: orderId }, { completedAt });
  }

  async getDriverStats(): Promise<Array<{
    driverId: number;
    driverName: string;
    completedOrders: number;
    averageDeliveryTime: number;
  }>> {
    const stats = await this.orderRepo
      .createQueryBuilder('order')
      .select('order.driver_id', 'driverId')
      .addSelect('user.name', 'driverName')
      .addSelect('COUNT(order.id)', 'completedOrders')
      .addSelect(
        'AVG(TIMESTAMPDIFF(MINUTE, order.delivered_at, order.completed_at))',
        'averageDeliveryTime'
      )
      .innerJoin('users', 'user', 'user.id = order.driver_id')
      .where('order.status = :status', { status: 'completed' })
      .andWhere('order.delivered_at IS NOT NULL')
      .andWhere('order.completed_at IS NOT NULL')
      .groupBy('order.driver_id')
      .orderBy('averageDeliveryTime', 'ASC')
      .limit(3)
      .getRawMany();

    return stats.map(stat => ({
      driverId: stat.driverId,
      driverName: stat.driverName,
      completedOrders: parseInt(stat.completedOrders),
      averageDeliveryTime: parseFloat(stat.averageDeliveryTime) || 0,
    }));
  }
}
