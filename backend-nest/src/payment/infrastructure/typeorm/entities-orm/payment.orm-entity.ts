import {
  Column,
  Entity,
  PrimaryGeneratedColumn,
  Index,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { UsersOrmEntity } from '../../../../auth/infrastructure/typeorm/entities-orm/users.orm-entity';
import { OrderOrmEntity } from '../../../../orders/infrastructure/typeorm/entities-orm/order.orm-entity';

@Entity({ name: 'payments' })
@Index('idx_payments_user_id', ['userId'])
@Index('idx_payments_stripe_payment_intent_id', ['stripePaymentIntentId'])
export class PaymentOrmEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'stripe_payment_intent_id', type: 'varchar', length: 255, unique: true })
  stripePaymentIntentId: string;

  @Column({ name: 'order_id', type: 'int', nullable: true })
  orderId: number | null;

  @ManyToOne(() => OrderOrmEntity, { eager: false })
  @JoinColumn({ name: 'order_id' })
  order: OrderOrmEntity;

  @Column({ name: 'user_id', type: 'int' })
  userId: number;

  @ManyToOne(() => UsersOrmEntity, { eager: false })
  @JoinColumn({ name: 'user_id' })
  user: UsersOrmEntity;

  @Column({ type: 'int', comment: 'Amount in cents' })
  amount: number;

  @Column({ type: 'varchar', length: 3, default: () => "'EUR'" })
  currency: string;

  @Column({ type: 'varchar', length: 32, default: () => "'pending'" })
  status: string; // pending|succeeded|failed|canceled

  @Column({ name: 'payment_method', type: 'varchar', length: 255, nullable: true })
  paymentMethod: string | null;

  @Column({ name: 'receipt_url', type: 'text', nullable: true })
  receiptUrl: string | null;

  @Column({ name: 'is_active', type: 'tinyint', width: 1, default: () => '1' })
  isActive: boolean;

  @Column({
    name: 'created_at',
    type: 'timestamp',
    default: () => 'CURRENT_TIMESTAMP',
  })
  createdAt: Date;

  @Column({
    name: 'updated_at',
    type: 'timestamp',
    default: () => 'CURRENT_TIMESTAMP',
    onUpdate: 'CURRENT_TIMESTAMP',
  })
  updatedAt: Date;
}
