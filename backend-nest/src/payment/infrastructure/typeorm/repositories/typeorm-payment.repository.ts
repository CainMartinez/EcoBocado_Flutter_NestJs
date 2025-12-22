import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PaymentOrmEntity } from '../entities-orm/payment.orm-entity';
import { IPaymentRepository } from '../../../domain/repositories/payment.repository.interface';
import { Payment } from '../../../domain/entities/payment.entity';

@Injectable()
export class TypeOrmPaymentRepository implements IPaymentRepository {
  constructor(
    @InjectRepository(PaymentOrmEntity)
    private readonly paymentRepo: Repository<PaymentOrmEntity>,
  ) {}

  async create(payment: {
    stripePaymentIntentId: string;
    userId: number;
    amount: number;
    currency: string;
    orderId?: number;
  }): Promise<Payment> {
    const paymentOrm = this.paymentRepo.create({
      stripePaymentIntentId: payment.stripePaymentIntentId,
      userId: payment.userId,
      amount: payment.amount,
      currency: payment.currency,
      orderId: payment.orderId ?? null,
      status: 'pending',
      isActive: true,
    });

    const saved = await this.paymentRepo.save(paymentOrm);

    return Payment.fromPrimitives({
      id: saved.id,
      stripePaymentIntentId: saved.stripePaymentIntentId,
      orderId: saved.orderId,
      userId: saved.userId,
      amount: saved.amount,
      currency: saved.currency,
      status: saved.status as any,
      paymentMethod: saved.paymentMethod,
      receiptUrl: saved.receiptUrl,
      isActive: saved.isActive,
      createdAt: saved.createdAt,
      updatedAt: saved.updatedAt,
    });
  }

  async updateStatus(
    paymentIntentId: string,
    status: string,
    options?: {
      paymentMethod?: string;
      receiptUrl?: string;
      orderId?: number;
    },
  ): Promise<void> {
    const updateData: any = { status };
    
    if (options?.paymentMethod) {
      updateData.paymentMethod = options.paymentMethod;
    }
    if (options?.receiptUrl) {
      updateData.receiptUrl = options.receiptUrl;
    }
    if (options?.orderId) {
      updateData.orderId = options.orderId;
    }

    await this.paymentRepo.update(
      { stripePaymentIntentId: paymentIntentId },
      updateData,
    );
  }

  async findByPaymentIntentId(paymentIntentId: string): Promise<Payment | null> {
    const paymentOrm = await this.paymentRepo.findOne({
      where: { stripePaymentIntentId: paymentIntentId, isActive: true },
    });

    if (!paymentOrm) return null;

    return Payment.fromPrimitives({
      id: paymentOrm.id,
      stripePaymentIntentId: paymentOrm.stripePaymentIntentId,
      orderId: paymentOrm.orderId,
      userId: paymentOrm.userId,
      amount: paymentOrm.amount,
      currency: paymentOrm.currency,
      status: paymentOrm.status as any,
      paymentMethod: paymentOrm.paymentMethod,
      receiptUrl: paymentOrm.receiptUrl,
      isActive: paymentOrm.isActive,
      createdAt: paymentOrm.createdAt,
      updatedAt: paymentOrm.updatedAt,
    });
  }

  async findByOrderId(orderId: number): Promise<Payment[]> {
    const paymentsOrm = await this.paymentRepo.find({
      where: { orderId, isActive: true },
    });

    return paymentsOrm.map((p) =>
      Payment.fromPrimitives({
        id: p.id,
        stripePaymentIntentId: p.stripePaymentIntentId,
        orderId: p.orderId,
        userId: p.userId,
        amount: p.amount,
        currency: p.currency,
        status: p.status as any,
        paymentMethod: p.paymentMethod,
        receiptUrl: p.receiptUrl,
        isActive: p.isActive,
        createdAt: p.createdAt,
        updatedAt: p.updatedAt,
      }),
    );
  }

  async findByUserId(userId: number): Promise<Payment[]> {
    const paymentsOrm = await this.paymentRepo.find({
      where: { userId, isActive: true },
      order: { createdAt: 'DESC' },
    });

    return paymentsOrm.map((p) =>
      Payment.fromPrimitives({
        id: p.id,
        stripePaymentIntentId: p.stripePaymentIntentId,
        orderId: p.orderId,
        userId: p.userId,
        amount: p.amount,
        currency: p.currency,
        status: p.status as any,
        paymentMethod: p.paymentMethod,
        receiptUrl: p.receiptUrl,
        isActive: p.isActive,
        createdAt: p.createdAt,
        updatedAt: p.updatedAt,
      }),
    );
  }
}
