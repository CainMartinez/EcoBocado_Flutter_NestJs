import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import { UserAddressOrmEntity } from '../entities-orm/user-address.orm-entity';
import { IUserAddressRepository } from '../../../domain/repositories/user-address.repository.interface';
import { UserAddress } from '../../../domain/entities/user-address.entity';

@Injectable()
export class TypeOrmUserAddressRepository implements IUserAddressRepository {
  constructor(
    @InjectRepository(UserAddressOrmEntity)
    private readonly userAddressRepo: Repository<UserAddressOrmEntity>,
    private readonly dataSource: DataSource,
  ) {}

  async create(
    userId: number,
    data: {
      label: string;
      addressLine1: string;
      addressLine2?: string;
      city: string;
      stateProvince?: string;
      postalCode: string;
      country?: string;
      phone?: string;
      isDefault?: boolean;
    },
  ): Promise<UserAddress> {
    return await this.dataSource.transaction(async (manager) => {
      // Si es default, desmarcar todas las otras direcciones del usuario
      if (data.isDefault) {
        await manager.update(
          UserAddressOrmEntity,
          { userId, isActive: true },
          { isDefault: false },
        );
      }

      // Crear la nueva dirección directamente con insert
      const result = await manager.insert(UserAddressOrmEntity, {
        userId,
        label: data.label,
        addressLine1: data.addressLine1,
        addressLine2: data.addressLine2 ?? null,
        city: data.city,
        stateProvince: data.stateProvince ?? null,
        postalCode: data.postalCode,
        country: data.country ?? 'España',
        phone: data.phone ?? null,
        isDefault: data.isDefault ?? false,
        isActive: true,
      });

      // Obtener la dirección recién creada
      const saved = await manager.findOne(UserAddressOrmEntity, {
        where: { id: result.identifiers[0].id },
      });

      if (!saved) {
        throw new Error('Failed to create user address');
      }

      return UserAddress.fromPrimitives({
        id: saved.id,
        userId: saved.userId,
        label: saved.label,
        addressLine1: saved.addressLine1,
        addressLine2: saved.addressLine2,
        city: saved.city,
        stateProvince: saved.stateProvince,
        postalCode: saved.postalCode,
        country: saved.country,
        phone: saved.phone,
        isDefault: saved.isDefault,
        isActive: saved.isActive,
        createdAt: saved.createdAt,
        updatedAt: saved.updatedAt,
      });
    });
  }

  async findByUserId(userId: number): Promise<UserAddress[]> {
    const addresses = await this.userAddressRepo.find({
      where: { userId, isActive: true },
      order: { isDefault: 'DESC', createdAt: 'DESC' },
    });

    return addresses.map((addr) =>
      UserAddress.fromPrimitives({
        id: addr.id,
        userId: addr.userId,
        label: addr.label,
        addressLine1: addr.addressLine1,
        addressLine2: addr.addressLine2,
        city: addr.city,
        stateProvince: addr.stateProvince,
        postalCode: addr.postalCode,
        country: addr.country,
        phone: addr.phone,
        isDefault: addr.isDefault,
        isActive: addr.isActive,
        createdAt: addr.createdAt,
        updatedAt: addr.updatedAt,
      }),
    );
  }

  async findById(id: number): Promise<UserAddress | null> {
    const addressOrm = await this.userAddressRepo.findOne({
      where: { id, isActive: true },
    });

    if (!addressOrm) return null;

    return UserAddress.fromPrimitives({
      id: addressOrm.id,
      userId: addressOrm.userId,
      label: addressOrm.label,
      addressLine1: addressOrm.addressLine1,
      addressLine2: addressOrm.addressLine2,
      city: addressOrm.city,
      stateProvince: addressOrm.stateProvince,
      postalCode: addressOrm.postalCode,
      country: addressOrm.country,
      phone: addressOrm.phone,
      isDefault: addressOrm.isDefault,
      isActive: addressOrm.isActive,
      createdAt: addressOrm.createdAt,
      updatedAt: addressOrm.updatedAt,
    });
  }

  async update(
    id: number,
    data: {
      label?: string;
      addressLine1?: string;
      addressLine2?: string;
      city?: string;
      stateProvince?: string;
      postalCode?: string;
      country?: string;
      phone?: string;
    },
  ): Promise<UserAddress> {
    await this.userAddressRepo.update({ id }, data);

    const updated = await this.userAddressRepo.findOne({ where: { id } });
    if (!updated) {
      throw new Error('Address not found after update');
    }

    return UserAddress.fromPrimitives({
      id: updated.id,
      userId: updated.userId,
      label: updated.label,
      addressLine1: updated.addressLine1,
      addressLine2: updated.addressLine2,
      city: updated.city,
      stateProvince: updated.stateProvince,
      postalCode: updated.postalCode,
      country: updated.country,
      phone: updated.phone,
      isDefault: updated.isDefault,
      isActive: updated.isActive,
      createdAt: updated.createdAt,
      updatedAt: updated.updatedAt,
    });
  }

  async setAsDefault(userId: number, addressId: number): Promise<void> {
    await this.dataSource.transaction(async (manager) => {
      // Desmarcar todas las direcciones del usuario
      await manager.update(
        UserAddressOrmEntity,
        { userId, isActive: true },
        { isDefault: false },
      );

      // Marcar la dirección seleccionada como default
      await manager.update(
        UserAddressOrmEntity,
        { id: addressId, userId },
        { isDefault: true },
      );
    });
  }

  async delete(id: number): Promise<void> {
    await this.userAddressRepo.update({ id }, { isActive: false });
  }

  async findDefaultByUserId(userId: number): Promise<UserAddress | null> {
    const addressOrm = await this.userAddressRepo.findOne({
      where: { userId, isDefault: true, isActive: true },
    });

    if (!addressOrm) return null;

    return UserAddress.fromPrimitives({
      id: addressOrm.id,
      userId: addressOrm.userId,
      label: addressOrm.label,
      addressLine1: addressOrm.addressLine1,
      addressLine2: addressOrm.addressLine2,
      city: addressOrm.city,
      stateProvince: addressOrm.stateProvince,
      postalCode: addressOrm.postalCode,
      country: addressOrm.country,
      phone: addressOrm.phone,
      isDefault: addressOrm.isDefault,
      isActive: addressOrm.isActive,
      createdAt: addressOrm.createdAt,
      updatedAt: addressOrm.updatedAt,
    });
  }
}
