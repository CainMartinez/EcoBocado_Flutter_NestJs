import { Injectable, Inject, NotFoundException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { IDeliveryDriverRepository } from '../../domain/repositories/delivery-driver.repository';
import { MinioClientService } from '../../../media/infrastructure/adapters/minio-client.service';
import { DeliveryDriver } from '../../domain/entities/delivery-driver.entity';

@Injectable()
export class UploadDeliveryAvatarUseCase {
  constructor(
    @Inject(IDeliveryDriverRepository)
    private readonly driverRepository: IDeliveryDriverRepository,
    private readonly minioService: MinioClientService,
    private readonly configService: ConfigService,
  ) {}

  /**
   * Sube un avatar para el perfil del repartidor
   */
  async execute(
    driverId: number,
    file: Express.Multer.File,
  ): Promise<DeliveryDriver> {
    // Buscar el repartidor
    const driver = await this.driverRepository.findById(driverId);
    if (!driver) {
      throw new NotFoundException('Repartidor no encontrado');
    }

    // Subir a MinIO (usa el tipo 'user-avatar' ya que MinIO ya tiene ese bucket configurado)
    const { path } = await this.minioService.uploadFile(file, 'user-avatar');

    // Construir URL completa
    const baseUrl = this.configService.get<string>('MINIO_PUBLIC_URL') || 'http://localhost:9000';
    const avatarUrl = `${baseUrl}${path}`;

    // Actualizar repartidor con nueva URL
    const updatedDriver = await this.driverRepository.update(driverId, { avatarUrl });

    return updatedDriver;
  }
}
