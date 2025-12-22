import { Delivery } from '../../domain/entities/delivery.entity';

export const DELIVERY_REPOSITORY_TOKEN = Symbol('IDeliveryRepository');

export interface IDeliveryRepository {
  /**
   * Crear un registro de delivery para una orden
   */
  create(data: {
    orderId: number;
    userAddressId?: number;
    addressLine1: string;
    addressLine2?: string;
    city: string;
    stateProvince?: string;
    postalCode: string;
    country?: string;
    phone: string;
    deliveryNotes?: string;
    estimatedDeliveryDate?: Date;
    estimatedDeliveryTimeStart?: string;
    estimatedDeliveryTimeEnd?: string;
  }): Promise<Delivery>;

  /**
   * Obtener delivery por ID de orden
   */
  findByOrderId(orderId: number): Promise<Delivery | null>;

  /**
   * Actualizar el estado de un delivery
   */
  updateStatus(
    deliveryId: number,
    status: 'pending' | 'assigned' | 'preparing' | 'in_transit' | 'delivered' | 'failed' | 'cancelled',
  ): Promise<void>;

  /**
   * Asignar un conductor a un delivery
   */
  assignDriver(deliveryId: number, driverId: number): Promise<void>;

  /**
   * Obtener todos los deliveries asignados a un conductor
   */
  findByDriverId(driverId: number): Promise<Delivery[]>;
}
