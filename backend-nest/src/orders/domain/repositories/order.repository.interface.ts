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
}

export const ORDER_REPOSITORY_TOKEN = Symbol('ORDER_REPOSITORY_TOKEN');
