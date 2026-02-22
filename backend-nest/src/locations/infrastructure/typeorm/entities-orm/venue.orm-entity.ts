import { Column, Entity, Index, PrimaryGeneratedColumn } from 'typeorm';

@Entity({ name: 'venues' })
@Index('UQ_venues_code', ['code'], { unique: true })
export class VenueOrmEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'char', length: 36, nullable: true, unique: true })
  uuid: string | null;

  @Column({ type: 'varchar', length: 50, nullable: true })
  code: string | null;

  @Column({ type: 'varchar', length: 190, nullable: true })
  name: string | null;

  @Column({ type: 'varchar', length: 190, nullable: true, unique: true })
  email: string | null;

  @Column({ name: 'password_hash', type: 'varchar', length: 255, nullable: true })
  passwordHash: string | null;

  @Column({ name: 'avatar_url', type: 'varchar', length: 255, nullable: true })
  avatarUrl: string | null;

  @Column({ type: 'varchar', length: 20, nullable: true })
  phone: string | null;

  @Column({
    type: 'varchar',
    length: 50,
    default: () => "'Europe/Madrid'",
  })
  timezone: string;

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