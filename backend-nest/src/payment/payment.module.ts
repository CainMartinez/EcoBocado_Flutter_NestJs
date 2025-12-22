import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PaymentOrmEntity } from './infrastructure/typeorm/entities-orm/payment.orm-entity';
import { TypeOrmPaymentRepository } from './infrastructure/typeorm/repositories/typeorm-payment.repository';
import { PAYMENT_REPOSITORY_TOKEN } from './domain/repositories/payment.repository.interface';
import { StripeService } from './infrastructure/stripe/stripe.service';
import { CreatePaymentIntentUseCase } from './application/use_cases/create-payment-intent.use-case';
import { GetPaymentStatusUseCase } from './application/use_cases/get-payment-status.use-case';
import { PaymentController } from './presentation/controllers/payment.controller';

@Module({
  imports: [TypeOrmModule.forFeature([PaymentOrmEntity])],
  controllers: [PaymentController],
  providers: [
    {
      provide: PAYMENT_REPOSITORY_TOKEN,
      useClass: TypeOrmPaymentRepository,
    },
    StripeService,
    CreatePaymentIntentUseCase,
    GetPaymentStatusUseCase,
  ],
  exports: [PAYMENT_REPOSITORY_TOKEN, StripeService],
})
export class PaymentModule {}
