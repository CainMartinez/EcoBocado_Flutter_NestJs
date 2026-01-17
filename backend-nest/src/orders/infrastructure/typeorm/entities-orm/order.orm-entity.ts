import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
  Index,
} from 'typeorm';
import { UsersOrmEntity } from '../../../../auth/infrastructure/typeorm/entities-orm/users.orm-entity';
import { PickupSlotOrmEntity } from '../../../../locations/infrastructure/typeorm/entities-orm/pickup-slot.orm-entity';

@Entity({ name: 'orders' })
@Index('idx_orders_user_id', ['userId'])
export class OrderOrmEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'char', length: 36, nullable: true, unique: true })
  uuid: string | null;

  @Column({ name: 'user_id', type: 'int' })
  userId: number;

  @ManyToOne(() => UsersOrmEntity, { eager: false })
  @JoinColumn({ name: 'user_id' })
  user: UsersOrmEntity;

  @Column({ type: 'varchar', length: 32, default: () => "'confirmed'" })
  status: string; // draft|confirmed|prepared|delivered|cancelled

  @Column({ name: 'delivery_type', type: 'enum', enum: ['pickup', 'delivery'], default: 'pickup' })
  deliveryType: 'pickup' | 'delivery';

  @Column({ name: 'pickup_slot_id', type: 'int', nullable: true })
  pickupSlotId: number | null;

  @ManyToOne(() => PickupSlotOrmEntity, { eager: false })
  @JoinColumn({ name: 'pickup_slot_id' })
  pickupSlot: PickupSlotOrmEntity;

  @Column({ name: 'driver_id', type: 'int', nullable: true })
  driverId: number | null;

  @Column({ name: 'payment_intent_id', type: 'varchar', length: 255, nullable: true })
  paymentIntentId: string | null;

  @Column({ type: 'decimal', precision: 10, scale: 2, default: () => '0.00' })
  subtotal: number;

  @Column({ type: 'decimal', precision: 10, scale: 2, default: () => '0.00' })
  total: number;

  @Column({ type: 'varchar', length: 3, default: () => "'EUR'" })
  currency: string;

  @Column({ type: 'text', nullable: true })
  notes: string | null;

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