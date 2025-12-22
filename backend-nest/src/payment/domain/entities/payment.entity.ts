export type PaymentStatus = 'pending' | 'succeeded' | 'failed' | 'canceled';

export class Payment {
  readonly id: number;
  readonly stripePaymentIntentId: string;
  readonly orderId: number | null;
  readonly userId: number;
  
  readonly amount: number; // centavos
  readonly currency: string;
  readonly status: PaymentStatus;
  
  readonly paymentMethod: string | null;
  readonly receiptUrl: string | null;
  
  readonly isActive: boolean;
  readonly createdAt: Date;
  readonly updatedAt: Date;

  constructor(props: {
    id: number;
    stripePaymentIntentId: string;
    orderId: number | null;
    userId: number;
    amount: number;
    currency: string;
    status: PaymentStatus;
    paymentMethod: string | null;
    receiptUrl: string | null;
    isActive: boolean;
    createdAt: Date;
    updatedAt: Date;
  }) {
    this.id = props.id;
    this.stripePaymentIntentId = props.stripePaymentIntentId;
    this.orderId = props.orderId ?? null;
    this.userId = props.userId;
    this.amount = props.amount;
    this.currency = props.currency;
    this.status = props.status;
    this.paymentMethod = props.paymentMethod ?? null;
    this.receiptUrl = props.receiptUrl ?? null;
    this.isActive = props.isActive;
    this.createdAt = props.createdAt;
    this.updatedAt = props.updatedAt;
  }

  static fromPrimitives(p: {
    id: number;
    stripePaymentIntentId: string;
    orderId: number | null;
    userId: number;
    amount: number;
    currency: string;
    status: PaymentStatus;
    paymentMethod: string | null;
    receiptUrl: string | null;
    isActive: boolean;
    createdAt: Date;
    updatedAt: Date;
  }): Payment {
    return new Payment(p);
  }
}
