import { Inject, Injectable, NotFoundException } from '@nestjs/common';
import type { IPaymentRepository } from '../../domain/repositories/payment.repository.interface';
import { PAYMENT_REPOSITORY_TOKEN } from '../../domain/repositories/payment.repository.interface';
import { StripeService } from '../../infrastructure/stripe/stripe.service';
import { PaymentResponseDto } from '../dto/response/payment.response.dto';

@Injectable()
export class GetPaymentStatusUseCase {
  constructor(
    @Inject(PAYMENT_REPOSITORY_TOKEN)
    private readonly paymentRepository: IPaymentRepository,
    private readonly stripeService: StripeService,
  ) {}

  async execute(paymentIntentId: string): Promise<PaymentResponseDto> {
    // Buscar el pago en nuestra base de datos
    const payment = await this.paymentRepository.findByPaymentIntentId(paymentIntentId);

    if (!payment) {
      throw new NotFoundException(`Payment with intent ID ${paymentIntentId} not found`);
    }

    // Verificar estado en Stripe
    const stripePaymentIntent = await this.stripeService.retrievePaymentIntent(paymentIntentId);

    // Actualizar estado si ha cambiado
    if (stripePaymentIntent.status !== payment.status) {
      const statusMap: Record<string, string> = {
        'requires_payment_method': 'pending',
        'requires_confirmation': 'pending',
        'requires_action': 'pending',
        'processing': 'pending',
        'succeeded': 'succeeded',
        'canceled': 'canceled',
      };

      const newStatus = statusMap[stripePaymentIntent.status] || 'failed';

      await this.paymentRepository.updateStatus(paymentIntentId, newStatus, {
        paymentMethod: stripePaymentIntent.payment_method?.toString() || undefined,
      });

      // Refrescar el pago
      const updatedPayment = await this.paymentRepository.findByPaymentIntentId(paymentIntentId);
      
      return this.toResponseDto(updatedPayment!);
    }

    return this.toResponseDto(payment);
  }

  private toResponseDto(payment: any): PaymentResponseDto {
    return {
      id: payment.id,
      stripePaymentIntentId: payment.stripePaymentIntentId,
      orderId: payment.orderId,
      userId: payment.userId,
      amount: payment.amount,
      currency: payment.currency,
      status: payment.status,
      paymentMethod: payment.paymentMethod,
      receiptUrl: payment.receiptUrl,
      createdAt: payment.createdAt,
      updatedAt: payment.updatedAt,
    };
  }
}
