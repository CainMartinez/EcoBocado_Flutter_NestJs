import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('delivery_locations')
export class DeliveryLocationOrmEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'delivery_user_id' })
  deliveryUserId: number;

  @Column({ name: 'order_id', nullable: true, type: 'int' })
  orderId?: number;

  @Column('decimal', { precision: 10, scale: 8 })
  latitude: number;

  @Column('decimal', { precision: 11, scale: 8 })
  longitude: number;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
