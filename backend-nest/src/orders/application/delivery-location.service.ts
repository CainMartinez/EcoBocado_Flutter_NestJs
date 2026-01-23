import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { DeliveryLocationOrmEntity } from '../infrastructure/typeorm/entities-orm/delivery-location.orm-entity';
import { UpdateLocationDto } from '../presentation/dto/update-location.dto';
import { DeliveryLocationResponseDto } from '../presentation/dto/delivery-location-response.dto';

@Injectable()
export class DeliveryLocationService {
  constructor(
    @InjectRepository(DeliveryLocationOrmEntity)
    private readonly locationRepository: Repository<DeliveryLocationOrmEntity>,
  ) {}

  async updateLocation(
    deliveryUserId: number,
    updateLocationDto: UpdateLocationDto,
  ): Promise<DeliveryLocationResponseDto> {
    // Buscar si existe una ubicación para este usuario
    let location = await this.locationRepository.findOne({
      where: { deliveryUserId },
    });

    if (location) {
      // Actualizar ubicación existente
      location.latitude = updateLocationDto.latitude;
      location.longitude = updateLocationDto.longitude;
      // NO actualizamos orderId, la ubicación es del repartidor, no del pedido
    } else {
      // Crear nueva ubicación
      location = this.locationRepository.create({
        deliveryUserId,
        latitude: updateLocationDto.latitude,
        longitude: updateLocationDto.longitude,
        // NO guardamos orderId, la ubicación es del repartidor para TODOS sus pedidos
      });
    }

    const saved = await this.locationRepository.save(location);

    return {
      deliveryUserId: saved.deliveryUserId,
      orderId: saved.orderId ?? null,
      latitude: Number(saved.latitude),
      longitude: Number(saved.longitude),
      updatedAt: saved.updatedAt,
    };
  }

  async getLocationByOrderId(orderId: number): Promise<DeliveryLocationResponseDto | null> {
    // Primero buscamos el pedido para obtener el driverId
    const order = await this.locationRepository.manager.query(
      'SELECT driver_id FROM orders WHERE id = ?',
      [orderId]
    );

    if (!order || order.length === 0 || !order[0].driver_id) {
      return null; // Pedido no encontrado o sin repartidor asignado
    }

    const driverId = order[0].driver_id;

    // Ahora buscamos la ubicación más reciente de ese repartidor
    const location = await this.locationRepository.findOne({
      where: { deliveryUserId: driverId },
      order: { updatedAt: 'DESC' },
    });

    if (!location) {
      return null;
    }

    return {
      deliveryUserId: location.deliveryUserId,
      orderId: location.orderId ?? null,
      latitude: Number(location.latitude),
      longitude: Number(location.longitude),
      updatedAt: location.updatedAt,
    };
  }

  async getLocationByDeliveryUserId(deliveryUserId: number): Promise<DeliveryLocationResponseDto | null> {
    const location = await this.locationRepository.findOne({
      where: { deliveryUserId },
      order: { updatedAt: 'DESC' },
    });

    if (!location) {
      return null;
    }

    return {
      deliveryUserId: location.deliveryUserId,
      orderId: location.orderId ?? null,
      latitude: Number(location.latitude),
      longitude: Number(location.longitude),
      updatedAt: location.updatedAt,
    };
  }
}
