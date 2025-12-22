import { Payment } from '../entities/payment.entity';

export interface IPaymentRepository {
  /**
   * Crea un nuevo registro de pago
   */
  create(payment: {
    stripePaymentIntentId: string;
    userId: number;
    amount: number;
    currency: string;
    orderId?: number;
  }): Promise<Payment>;

  /**
   * Actualiza el estado de un pago
   */
  updateStatus(
    paymentIntentId: string,
    status: string,
    options?: {
      paymentMethod?: string;
      receiptUrl?: string;
      orderId?: number;
    },
  ): Promise<void>;

  /**
   * Busca un pago por su Payment Intent ID de Stripe
   */
  findByPaymentIntentId(paymentIntentId: string): Promise<Payment | null>;

  /**
   * Busca pagos por ID de orden
   */
  findByOrderId(orderId: number): Promise<Payment[]>;

  /**
   * Busca pagos por usuario
   */
  findByUserId(userId: number): Promise<Payment[]>;
}

export const PAYMENT_REPOSITORY_TOKEN = Symbol('PAYMENT_REPOSITORY_TOKEN');
