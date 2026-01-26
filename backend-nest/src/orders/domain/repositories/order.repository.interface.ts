import { Order, DeliveryType } from '../entities/order.entity';
import { OrderItem } from '../entities/order-item.entity';

export interface IOrderRepository {
  /**
   * Crea una nueva orden con sus items
   */
  createOrder(
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
      pickupDate?: string;
      pickupStartTime?: string;
      pickupEndTime?: string;
      venueId?: number;
      notes?: string;
      paymentIntentId?: string;
    },
  ): Promise<{ order: Order; items: OrderItem[] }>;

  /**
   * Busca una orden por su ID
   */
  findById(orderId: number): Promise<{ order: Order; items: OrderItem[] } | null>;

  /**
   * Busca todas las órdenes de un usuario
   */
  findByUserId(userId: number): Promise<Array<{ order: Order; items: OrderItem[] }>>;

  /**
   * Actualiza el estado de una orden
   */
  updateStatus(orderId: number, status: string): Promise<void>;

  /**
   * Actualiza el estado y el repartidor de una orden
   */
  updateStatusAndDriver(orderId: number, status: string, driverId: number): Promise<void>;

  /**
   * Actualiza el timestamp de cuando se acepta/asigna el pedido
   */
  updateDeliveredAt(orderId: number, deliveredAt: Date): Promise<void>;

  /**
   * Actualiza el timestamp de cuando se completa el pedido
   */
  updateCompletedAt(orderId: number, completedAt: Date): Promise<void>;

  /**
   * Obtiene estadísticas de velocidad de repartidores (top 3 más rápidos)
   */
  getDriverStats(): Promise<Array<{
    driverId: number;
    driverName: string;
    completedOrders: number;
    averageDeliveryTime: number; // en minutos
  }>>;
}

export const ORDER_REPOSITORY_TOKEN = Symbol('ORDER_REPOSITORY_TOKEN');
