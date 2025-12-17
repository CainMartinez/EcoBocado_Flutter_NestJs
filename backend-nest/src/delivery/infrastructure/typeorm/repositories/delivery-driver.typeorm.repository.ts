import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { DeliveryDriverOrmEntity } from '../entities-orm/delivery-driver.orm-entity';
import { IDeliveryDriverRepository } from '../../../domain/repositories/delivery-driver.repository';
import { DeliveryDriver } from '../../../domain/entities/delivery-driver.entity';

@Injectable()
export class DeliveryDriverTypeOrmRepository implements IDeliveryDriverRepository {
  constructor(
    @InjectRepository(DeliveryDriverOrmEntity)
    private readonly repo: Repository<DeliveryDriverOrmEntity>,
  ) {}

  async findById(id: number): Promise<DeliveryDriver | null> {
    const orm = await this.repo.findOne({ where: { id } });
    return orm ? DeliveryDriver.fromPrimitives(orm) : null;
  }

  async findByEmail(email: string): Promise<DeliveryDriver | null> {
    const orm = await this.repo.findOne({ where: { email: email.toLowerCase() } });
    return orm ? DeliveryDriver.fromPrimitives(orm) : null;
  }

  async findByUuid(uuid: string): Promise<DeliveryDriver | null> {
    const orm = await this.repo.findOne({ where: { uuid } });
    return orm ? DeliveryDriver.fromPrimitives(orm) : null;
  }

  async save(driver: DeliveryDriver): Promise<DeliveryDriver> {
    const orm = await this.repo.save(driver.toPrimitives());
    return DeliveryDriver.fromPrimitives(orm);
  }

  async create(data: Partial<DeliveryDriver>): Promise<DeliveryDriver> {
    const orm = this.repo.create(data);
    const saved = await this.repo.save(orm);
    return DeliveryDriver.fromPrimitives(saved);
  }

  async update(id: number, data: Partial<DeliveryDriver>): Promise<DeliveryDriver> {
    await this.repo.update(id, data as any);
    const updated = await this.findById(id);
    if (!updated) throw new Error('Driver not found after update');
    return updated;
  }
}
