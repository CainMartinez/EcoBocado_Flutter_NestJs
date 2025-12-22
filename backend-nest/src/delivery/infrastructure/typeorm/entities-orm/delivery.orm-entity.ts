import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { OrderOrmEntity } from '../../../../orders/infrastructure/typeorm/entities-orm/order.orm-entity';
import { UserAddressOrmEntity } from '../../../../profile/infrastructure/typeorm/entities-orm/user-address.orm-entity';
import { UsersOrmEntity } from '../../../../auth/infrastructure/typeorm/entities-orm/users.orm-entity';

@Entity({ name: 'deliveries' })
export class DeliveryOrmEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'order_id', type: 'int', unique: true })
  orderId: number;

  @Column({ name: 'user_address_id', type: 'int', nullable: true })
  userAddressId: number | null;

  @Column({ name: 'address_line1', type: 'varchar', length: 255 })
  addressLine1: string;

  @Column({ name: 'address_line2', type: 'varchar', length: 255, nullable: true })
  addressLine2: string | null;

  @Column({ type: 'varchar', length: 100 })
  city: string;

  @Column({ name: 'state_province', type: 'varchar', length: 100, nullable: true })
  stateProvince: string | null;

  @Column({ name: 'postal_code', type: 'varchar', length: 20 })
  postalCode: string;

  @Column({ type: 'varchar', length: 100, default: 'España' })
  country: string;

  @Column({ type: 'varchar', length: 20, nullable: true })
  phone: string | null;

  @Column({ name: 'delivery_notes', type: 'text', nullable: true })
  deliveryNotes: string | null;

  @Column({ name: 'estimated_delivery_date', type: 'date', nullable: true })
  estimatedDeliveryDate: Date | null;

  @Column({ name: 'estimated_delivery_time_start', type: 'time', nullable: true })
  estimatedDeliveryTimeStart: string | null;

  @Column({ name: 'estimated_delivery_time_end', type: 'time', nullable: true })
  estimatedDeliveryTimeEnd: string | null;

  @Column({
    name: 'delivery_status',
    type: 'enum',
    enum: ['pending', 'assigned', 'preparing', 'in_transit', 'delivered', 'failed', 'cancelled'],
    default: 'pending',
  })
  deliveryStatus: string;

  @Column({ name: 'driver_id', type: 'int', nullable: true })
  driverId: number | null;

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

  @OneToOne(() => OrderOrmEntity)
  @JoinColumn({ name: 'order_id' })
  order: OrderOrmEntity;

  @ManyToOne(() => UserAddressOrmEntity, { nullable: true })
  @JoinColumn({ name: 'user_address_id' })
  userAddress: UserAddressOrmEntity | null;

  @ManyToOne(() => UsersOrmEntity, { nullable: true })
  @JoinColumn({ name: 'driver_id' })
  driver: UsersOrmEntity | null;
}
