import { Injectable, Inject, NotFoundException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { IProfilesRepository } from '../../domain/repositories/profile.repository';
import { MinioClientService } from '../../../media/infrastructure/adapters/minio-client.service';
import { Profile } from '../../domain/entities/profile.entity';

@Injectable()
export class UploadAvatarUseCase {
  constructor(
    @Inject(IProfilesRepository)
    private readonly profileRepository: IProfilesRepository,
    private readonly minioService: MinioClientService,
    private readonly configService: ConfigService,
  ) {}

  /**
   * Sube un avatar para el perfil de usuario o admin
   */
  async execute(
    ownerType: 'user' | 'admin',
    ownerId: number,
    file: Express.Multer.File,
  ): Promise<Profile> {
    // Buscar el perfil
    const profile = await this.profileRepository.findByOwner(ownerType, ownerId);
    if (!profile) {
      throw new NotFoundException('Perfil no encontrado');
    }

    // Subir a MinIO
    const type = ownerType === 'admin' ? 'admin-avatar' : 'user-avatar';
    const { path } = await this.minioService.uploadFile(file, type);

    // Construir URL completa
    const baseUrl = this.configService.get<string>('MINIO_PUBLIC_URL') || 'http://localhost:9000';
    const avatarUrl = `${baseUrl}${path}`;

    // Actualizar perfil con nueva URL
    const updatedProfile = Profile.fromPrimitives({
      ...profile,
      avatarUrl,
    });

    return await this.profileRepository.update(updatedProfile);
  }
}
