import { Injectable, NotFoundException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { IVenueAuthRepository } from '../../domain/repositories/venue-auth.repository';
import { MinioClientService } from '../../../media/infrastructure/adapters/minio-client.service';
import { Venue } from '../../../locations/domain/entities/venue.entity';

@Injectable()
export class UploadRestaurantAvatarUseCase {
  constructor(
    private readonly venueRepo: IVenueAuthRepository,
    private readonly minioService: MinioClientService,
    private readonly configService: ConfigService,
  ) {}

  async execute(venueId: number, file: Express.Multer.File): Promise<Venue> {
    const venue = await this.venueRepo.findById(venueId);
    if (!venue) {
      throw new NotFoundException('Restaurante no encontrado');
    }

    const { path } = await this.minioService.uploadFile(file, 'user-avatar');
    const baseUrl = this.configService.get<string>('MINIO_PUBLIC_URL') || 'http://localhost:9000';
    const avatarUrl = `${baseUrl}${path}`;
    const updatedVenue = await this.venueRepo.update(venueId, { avatarUrl } as any);

    return updatedVenue;
  }
}
