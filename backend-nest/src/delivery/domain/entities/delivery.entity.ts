export type DeliveryStatus = 
  | 'pending' 
  | 'assigned' 
  | 'preparing' 
  | 'in_transit' 
  | 'delivered' 
  | 'failed' 
  | 'cancelled';

export class Delivery {
  readonly id: number;
  readonly orderId: number;
  readonly userAddressId: number | null;
  
  // Datos de dirección
  readonly addressLine1: string;
  readonly addressLine2: string | null;
  readonly city: string;
  readonly stateProvince: string | null;
  readonly postalCode: string;
  readonly country: string;
  readonly phone: string | null;
  
  // Información de entrega
  readonly deliveryNotes: string | null;
  readonly estimatedDeliveryDate: string | null; // 'YYYY-MM-DD'
  readonly estimatedDeliveryTime: string | null; // 'HH:MM:SS'
  readonly actualDeliveryAt: Date | null;
  
  readonly deliveryStatus: DeliveryStatus;
  readonly driverId: number | null;
  
  readonly isActive: boolean;
  readonly createdAt: Date;
  readonly updatedAt: Date;

  constructor(props: {
    id: number;
    orderId: number;
    userAddressId: number | null;
    addressLine1: string;
    addressLine2: string | null;
    city: string;
    stateProvince: string | null;
    postalCode: string;
    country: string;
    phone: string | null;
    deliveryNotes: string | null;
    estimatedDeliveryDate: string | null;
    estimatedDeliveryTime: string | null;
    actualDeliveryAt: Date | null;
    deliveryStatus: DeliveryStatus;
    driverId: number | null;
    isActive: boolean;
    createdAt: Date;
    updatedAt: Date;
  }) {
    this.id = props.id;
    this.orderId = props.orderId;
    this.userAddressId = props.userAddressId;
    this.addressLine1 = props.addressLine1;
    this.addressLine2 = props.addressLine2;
    this.city = props.city;
    this.stateProvince = props.stateProvince;
    this.postalCode = props.postalCode;
    this.country = props.country;
    this.phone = props.phone;
    this.deliveryNotes = props.deliveryNotes;
    this.estimatedDeliveryDate = props.estimatedDeliveryDate;
    this.estimatedDeliveryTime = props.estimatedDeliveryTime;
    this.actualDeliveryAt = props.actualDeliveryAt;
    this.deliveryStatus = props.deliveryStatus;
    this.driverId = props.driverId;
    this.isActive = props.isActive;
    this.createdAt = props.createdAt;
    this.updatedAt = props.updatedAt;
  }

  static fromPrimitives(p: {
    id: number;
    orderId: number;
    userAddressId: number | null;
    addressLine1: string;
    addressLine2: string | null;
    city: string;
    stateProvince: string | null;
    postalCode: string;
    country: string;
    phone: string | null;
    deliveryNotes: string | null;
    estimatedDeliveryDate: string | null;
    estimatedDeliveryTime: string | null;
    actualDeliveryAt: Date | null;
    deliveryStatus: DeliveryStatus;
    driverId: number | null;
    isActive: boolean;
    createdAt: Date;
    updatedAt: Date;
  }): Delivery {
    return new Delivery(p);
  }
}
