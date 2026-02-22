import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { VenueOrmEntity } from '../../../../locations/infrastructure/typeorm/entities-orm/venue.orm-entity';
import { IVenueAuthRepository } from '../../../domain/repositories/venue-auth.repository';
import { Venue } from '../../../../locations/domain/entities/venue.entity';

@Injectable()
export class VenueAuthTypeOrmRepository implements IVenueAuthRepository {
  constructor(
    @InjectRepository(VenueOrmEntity)
    private readonly repo: Repository<VenueOrmEntity>,
  ) {}

  async findById(id: number): Promise<Venue | null> {
    const orm = await this.repo.findOne({ where: { id } });
    return orm ? Venue.fromPrimitives(orm as any) : null;
  }

  async findByEmail(email: string): Promise<Venue | null> {
    const orm = await this.repo.findOne({ where: { email: email.toLowerCase() } });
    return orm ? Venue.fromPrimitives(orm as any) : null;
  }

  async update(id: number, data: Partial<Venue>): Promise<Venue> {
    await this.repo.update(id, data as any);
    const updated = await this.findById(id);
    if (!updated) throw new Error('Venue not found after update');
    return updated;
  }
}
