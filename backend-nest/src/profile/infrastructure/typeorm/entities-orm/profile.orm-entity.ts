import {
  Column,
  Entity,
  PrimaryGeneratedColumn,
  Index,
} from 'typeorm';

@Entity({ name: 'profiles' })
@Index(['ownerType', 'ownerId'], { unique: true })
export class ProfileOrmEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'owner_type', type: 'varchar', length: 10 })
  ownerType: 'user' | 'admin';

  @Column({ name: 'owner_id', type: 'int' })
  ownerId: number;

  @Column({ type: 'varchar', length: 50, nullable: true })
  phone: string | null;

  @Column({ name: 'address_line1', type: 'varchar', length: 190, nullable: true })
  addressLine1: string | null;

  @Column({ name: 'address_line2', type: 'varchar', length: 190, nullable: true })
  addressLine2: string | null;

  @Column({ type: 'varchar', length: 120, nullable: true })
  city: string | null;

  @Column({ name: 'postal_code', type: 'varchar', length: 30, nullable: true })
  postalCode: string | null;

  @Column({ name: 'country_code', type: 'char', length: 2, default: () => "'ES'" })
  countryCode: string;

  @Column({ name: 'avatar_url', type: 'varchar', length: 500, nullable: true })
  avatarUrl: string | null;

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