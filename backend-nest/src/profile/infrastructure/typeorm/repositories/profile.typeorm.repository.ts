import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ProfileOrmEntity } from '../entities-orm/profile.orm-entity';
import { Profile } from '../../../domain/entities/profile.entity';
import { IProfilesRepository } from '../../../domain/repositories/profile.repository';

@Injectable()
export class ProfilesTypeOrmRepository implements IProfilesRepository {
  constructor(
    @InjectRepository(ProfileOrmEntity)
    private readonly repo: Repository<ProfileOrmEntity>,
  ) {}

  async findByOwner(ownerType: 'user' | 'admin', ownerId: number): Promise<Profile | null> {
    const found = await this.repo.findOne({
      where: { ownerType, ownerId },
    });
    return found ? this.toDomain(found) : null;
  }

  async createForOwner(
    ownerType: 'user' | 'admin',
    ownerId: number,
    profile: Profile,
  ): Promise<Profile> {
    const orm = this.toOrm(profile);
    orm.ownerType = ownerType;
    orm.ownerId = ownerId;

    const saved = await this.repo.save(orm);
    return this.toDomain(saved);
  }

  async update(profile: Profile): Promise<Profile> {
    await this.repo.update(profile.id, this.toOrm(profile));
    const updated = await this.repo.findOne({ where: { id: profile.id } });
    return updated ? this.toDomain(updated) : profile;
  }

  private toDomain(orm: ProfileOrmEntity): Profile {
    return new Profile({
      id: orm.id,
      ownerType: orm.ownerType,
      ownerId: orm.ownerId,
      phone: orm.phone,
      addressLine1: orm.addressLine1,
      addressLine2: orm.addressLine2,
      city: orm.city,
      postalCode: orm.postalCode,
      countryCode: orm.countryCode,
      avatarUrl: orm.avatarUrl,
      isActive: orm.isActive,
      createdAt: orm.createdAt,
      updatedAt: orm.updatedAt,
    });
  }

  private toOrm(domain: Profile): ProfileOrmEntity {
    const orm = new ProfileOrmEntity();
    orm.id = domain.id;
    orm.ownerType = domain.ownerType;
    orm.ownerId = domain.ownerId;
    orm.phone = domain.phone;
    orm.addressLine1 = domain.addressLine1;
    orm.addressLine2 = domain.addressLine2;
    orm.city = domain.city;
    orm.postalCode = domain.postalCode;
    orm.countryCode = domain.countryCode;
    orm.avatarUrl = domain.avatarUrl;
    orm.isActive = domain.isActive;
    orm.createdAt = domain.createdAt;
    orm.updatedAt = domain.updatedAt;
    return orm;
  }
}