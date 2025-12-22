import { Inject, Injectable } from '@nestjs/common';
import { StripeService } from '../../infrastructure/stripe/stripe.service';
import type { IPaymentRepository } from '../../domain/repositories/payment.repository.interface';
import { PAYMENT_REPOSITORY_TOKEN } from '../../domain/repositories/payment.repository.interface';
import { CreatePaymentIntentRequestDto } from '../dto/request/create-payment-intent.request.dto';
import { PaymentIntentResponseDto } from '../dto/response/payment.response.dto';

@Injectable()
export class CreatePaymentIntentUseCase {
  constructor(
    @Inject(PAYMENT_REPOSITORY_TOKEN)
    private readonly paymentRepository: IPaymentRepository,
    private readonly stripeService: StripeService,
  ) {}

  async execute(
    userId: number,
    dto: CreatePaymentIntentRequestDto,
  ): Promise<PaymentIntentResponseDto> {
    // Crear el Payment Intent en Stripe
    const metadata: Record<string, string> = {
      userId: userId.toString(),
      ...(dto.metadata || {}),
    };

    if (dto.orderId) {
      metadata.orderId = dto.orderId.toString();
    }

    const paymentIntent = await this.stripeService.createPaymentIntent(
      dto.amount,
      dto.currency,
      metadata,
    );

    // Guardar el registro en nuestra base de datos
    await this.paymentRepository.create({
      stripePaymentIntentId: paymentIntent.id,
      userId,
      amount: dto.amount,
      currency: dto.currency.toUpperCase(),
      orderId: dto.orderId,
    });

    return {
      clientSecret: paymentIntent.client_secret!,
      paymentIntentId: paymentIntent.id,
      amount: paymentIntent.amount,
      currency: paymentIntent.currency,
      status: 'pending',
      orderId: dto.orderId,
    };
  }
}
