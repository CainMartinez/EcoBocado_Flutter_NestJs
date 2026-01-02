import { Injectable, NotFoundException } from '@nestjs/common';
import { IProfilesRepository } from '../../domain/repositories/profile.repository';
import { IUsersRepository } from '../../../auth/domain/repositories/users.repository';
import { IAdminsRepository } from '../../../auth/domain/repositories/admin.repository';
import { ProfileResponseDto } from '../dto/response/profile.response.dto';

@Injectable()
export class GetProfileUseCase {
  constructor(
    private readonly profilesRepo: IProfilesRepository,
    private readonly usersRepo: IUsersRepository,
    private readonly adminsRepo: IAdminsRepository,
  ) {}

  /**
   * Devuelve el perfil unificado para un owner (user|admin) identificado por email.
   * El email viene del JWT.
   */
  async execute(ownerType: 'user' | 'admin', email: string): Promise<ProfileResponseDto> {
    if (!email) {
      throw new NotFoundException('No se pudo determinar el email del sujeto autenticado.');
    }

    if (ownerType === 'user') {
      const user = await this.usersRepo.findByEmail(email.toLowerCase());
      if (!user) {
        throw new NotFoundException('Usuario no encontrado.');
      }

      const profile = await this.profilesRepo.findByOwner('user', user.id);

      return {
        ownerType: 'user',
        ownerId: user.id,
        email: user.email,
        name: user.name,
        avatarUrl: profile ? profile.avatarUrl : null,
        phone: profile ? profile.phone : null,
        addressLine1: profile ? profile.addressLine1 : null,
        addressLine2: profile ? profile.addressLine2 : null,
        city: profile ? profile.city : null,
        postalCode: profile ? profile.postalCode : null,
        countryCode: profile ? profile.countryCode : 'ES',
        isActive: profile ? profile.isActive : true,
        createdAt: profile ? profile.createdAt : user.createdAt,
        updatedAt: profile ? profile.updatedAt : user.updatedAt,
      };
    }

    const admin = await this.adminsRepo.findByEmail(email.toLowerCase());
    if (!admin) {
      throw new NotFoundException('Administrador no encontrado.');
    }

    const profile = await this.profilesRepo.findByOwner('admin', admin.id);

    return {
      ownerType: 'admin',
      ownerId: admin.id,
      email: admin.email,
      name: admin.name,
      avatarUrl: profile ? profile.avatarUrl : null,
      phone: profile ? profile.phone : null,
      addressLine1: profile ? profile.addressLine1 : null,
      addressLine2: profile ? profile.addressLine2 : null,
      city: profile ? profile.city : null,
      postalCode: profile ? profile.postalCode : null,
      countryCode: profile ? profile.countryCode : 'ES',
      isActive: profile ? profile.isActive : true,
      createdAt: profile ? profile.createdAt : admin.createdAt,
      updatedAt: profile ? profile.updatedAt : admin.updatedAt,
    };
  }
}