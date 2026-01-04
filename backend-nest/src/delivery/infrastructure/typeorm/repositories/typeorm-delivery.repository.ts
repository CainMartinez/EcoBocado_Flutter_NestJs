import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { DeliveryOrmEntity } from '../entities-orm/delivery.orm-entity';
import { IDeliveryRepository } from '../../../domain/repositories/delivery.repository.interface';
import { Delivery } from '../../../domain/entities/delivery.entity';

@Injectable()
export class TypeOrmDeliveryRepository implements IDeliveryRepository {
  constructor(
    @InjectRepository(DeliveryOrmEntity)
    private readonly deliveryRepo: Repository<DeliveryOrmEntity>,
  ) {}

  async create(data: {
    orderId: number;
    userAddressId?: number;
    addressLine1: string;
    addressLine2?: string;
    city: string;
    stateProvince?: string;
    postalCode: string;
    country?: string;
    phone?: string;
    deliveryNotes?: string;
    estimatedDeliveryDate?: Date;
    estimatedDeliveryTimeStart?: string;
    estimatedDeliveryTimeEnd?: string;
  }): Promise<Delivery> {
    const deliveryOrm = this.deliveryRepo.create({
      orderId: data.orderId,
      userAddressId: data.userAddressId ?? null,
      addressLine1: data.addressLine1,
      addressLine2: data.addressLine2 ?? null,
      city: data.city,
      stateProvince: data.stateProvince ?? null,
      postalCode: data.postalCode,
      country: data.country ?? 'España',
      phone: data.phone ?? null,
      deliveryNotes: data.deliveryNotes ?? null,
      estimatedDeliveryDate: data.estimatedDeliveryDate ?? null,
      estimatedDeliveryTimeStart: data.estimatedDeliveryTimeStart ?? null,
      estimatedDeliveryTimeEnd: data.estimatedDeliveryTimeEnd ?? null,
      deliveryStatus: 'pending',
      driverId: null,
    });

    const saved = await this.deliveryRepo.save(deliveryOrm);

    return Delivery.fromPrimitives({
      id: saved.id,
      orderId: saved.orderId,
      userAddressId: saved.userAddressId,
      addressLine1: saved.addressLine1,
      addressLine2: saved.addressLine2,
      city: saved.city,
      stateProvince: saved.stateProvince,
      postalCode: saved.postalCode,
      country: saved.country,
      phone: saved.phone,
      deliveryNotes: saved.deliveryNotes,
      estimatedDeliveryDate: saved.estimatedDeliveryDate 
        ? (saved.estimatedDeliveryDate instanceof Date 
            ? saved.estimatedDeliveryDate.toISOString().split('T')[0] 
            : String(saved.estimatedDeliveryDate).split('T')[0])
        : null,
      estimatedDeliveryTime: saved.estimatedDeliveryTimeStart ?? null,
      actualDeliveryAt: null,
      deliveryStatus: saved.deliveryStatus as any,
      driverId: saved.driverId,
      isActive: true,
      createdAt: saved.createdAt,
      updatedAt: saved.updatedAt,
    });
  }

  async findByOrderId(orderId: number): Promise<Delivery | null> {
    const deliveryOrm = await this.deliveryRepo.findOne({
      where: { orderId },
    });

    if (!deliveryOrm) return null;

    return Delivery.fromPrimitives({
      id: deliveryOrm.id,
      orderId: deliveryOrm.orderId,
      userAddressId: deliveryOrm.userAddressId,
      addressLine1: deliveryOrm.addressLine1,
      addressLine2: deliveryOrm.addressLine2,
      city: deliveryOrm.city,
      stateProvince: deliveryOrm.stateProvince,
      postalCode: deliveryOrm.postalCode,
      country: deliveryOrm.country,
      phone: deliveryOrm.phone,
      deliveryNotes: deliveryOrm.deliveryNotes,
      estimatedDeliveryDate: deliveryOrm.estimatedDeliveryDate 
        ? (deliveryOrm.estimatedDeliveryDate instanceof Date 
            ? deliveryOrm.estimatedDeliveryDate.toISOString().split('T')[0] 
            : String(deliveryOrm.estimatedDeliveryDate).split('T')[0])
        : null,
      estimatedDeliveryTime: deliveryOrm.estimatedDeliveryTimeStart ?? null,
      actualDeliveryAt: null,
      deliveryStatus: deliveryOrm.deliveryStatus as any,
      driverId: deliveryOrm.driverId,
      isActive: true,
      createdAt: deliveryOrm.createdAt,
      updatedAt: deliveryOrm.updatedAt,
    });
  }

  async updateStatus(
    deliveryId: number,
    status: 'pending' | 'assigned' | 'preparing' | 'in_transit' | 'delivered' | 'failed' | 'cancelled',
  ): Promise<void> {
    await this.deliveryRepo.update({ id: deliveryId }, { deliveryStatus: status });
  }

  async assignDriver(deliveryId: number, driverId: number): Promise<void> {
    await this.deliveryRepo.update(
      { id: deliveryId },
      { driverId, deliveryStatus: 'assigned' },
    );
  }

  async findByDriverId(driverId: number): Promise<Delivery[]> {
    const deliveries = await this.deliveryRepo.find({
      where: { driverId },
      order: { createdAt: 'DESC' },
    });

    return deliveries.map((d) =>
      Delivery.fromPrimitives({
        id: d.id,
        orderId: d.orderId,
        userAddressId: d.userAddressId,
        addressLine1: d.addressLine1,
        addressLine2: d.addressLine2,
        city: d.city,
        stateProvince: d.stateProvince,
        postalCode: d.postalCode,
        country: d.country,
        phone: d.phone,
        deliveryNotes: d.deliveryNotes,
        estimatedDeliveryDate: d.estimatedDeliveryDate 
          ? (d.estimatedDeliveryDate instanceof Date 
              ? d.estimatedDeliveryDate.toISOString().split('T')[0] 
              : String(d.estimatedDeliveryDate).split('T')[0])
          : null,
        estimatedDeliveryTime: d.estimatedDeliveryTimeStart ?? null,
        actualDeliveryAt: null,
        deliveryStatus: d.deliveryStatus as any,
        driverId: d.driverId,
        isActive: true,
        createdAt: d.createdAt,
        updatedAt: d.updatedAt,
      }),
    );
  }
}
