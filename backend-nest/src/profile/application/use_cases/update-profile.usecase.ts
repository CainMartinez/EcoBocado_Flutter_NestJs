import { Injectable, NotFoundException } from '@nestjs/common';
import { IProfilesRepository } from '../../domain/repositories/profile.repository';
import { IUsersRepository } from '../../../auth/domain/repositories/users.repository';
import { IAdminsRepository } from '../../../auth/domain/repositories/admin.repository';
import { UpdateProfileRequestDto } from '../dto/request/update-profile.request.dto';
import { ProfileResponseDto } from '../dto/response/profile.response.dto';
import { Profile } from '../../domain/entities/profile.entity';
import { User } from '../../../auth/domain/entities/users.entity';
import { Admin } from '../../../auth/domain/entities/admins.entity';

@Injectable()
export class UpdateProfileUseCase {
  constructor(
    private readonly profilesRepo: IProfilesRepository,
    private readonly usersRepo: IUsersRepository,
    private readonly adminsRepo: IAdminsRepository,
  ) {}

  async execute(
    ownerType: 'user' | 'admin',
    email: string,
    dto: UpdateProfileRequestDto,
  ): Promise<ProfileResponseDto> {
    if (!email) {
      throw new NotFoundException('No se pudo determinar el email del usuario autenticado.');
    }

    // Buscar el owner (user o admin)
    const owner = ownerType === 'user'
      ? await this.usersRepo.findByEmail(email.toLowerCase())
      : await this.adminsRepo.findByEmail(email.toLowerCase());

    if (!owner) {
      throw new NotFoundException(`${ownerType === 'user' ? 'Usuario' : 'Administrador'} no encontrado.`);
    }

    // Buscar o crear perfil
    let profile = await this.profilesRepo.findByOwner(ownerType, owner.id);

    if (!profile) {
      // Crear perfil si no existe (el repositorio se encarga de generar el ID)
      const newProfile = new Profile({
        id: 0, // temporal, será asignado por la BD
        ownerType,
        ownerId: owner.id,
        phone: dto.phone || null,
        addressLine1: dto.addressLine1 || null,
        addressLine2: dto.addressLine2 || null,
        city: dto.city || null,
        postalCode: dto.postalCode || null,
        countryCode: dto.countryCode || 'ES',
        avatarUrl: null,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date(),
      });
      profile = await this.profilesRepo.createForOwner(ownerType, owner.id, newProfile);
    } else {
      // Actualizar perfil existente (crear nueva entidad con datos actualizados)
      const updatedProfile = new Profile({
        id: profile.id,
        ownerType: profile.ownerType,
        ownerId: profile.ownerId,
        phone: dto.phone !== undefined ? dto.phone : profile.phone,
        addressLine1: dto.addressLine1 !== undefined ? dto.addressLine1 : profile.addressLine1,
        addressLine2: dto.addressLine2 !== undefined ? dto.addressLine2 : profile.addressLine2,
        city: dto.city !== undefined ? dto.city : profile.city,
        postalCode: dto.postalCode !== undefined ? dto.postalCode : profile.postalCode,
        countryCode: dto.countryCode !== undefined ? dto.countryCode : profile.countryCode,
        avatarUrl: profile.avatarUrl, // Mantener el avatar actual
        isActive: profile.isActive,
        createdAt: profile.createdAt,
        updatedAt: new Date(),
      });
      profile = await this.profilesRepo.update(updatedProfile);
    }

    // Actualizar avatar en la tabla de user/admin si se proporciona
    let updatedOwner = owner;
    if (dto.avatarUrl !== undefined) {
      if (ownerType === 'user') {
        const updatedUser = new User({
          ...owner,
          avatarUrl: dto.avatarUrl,
          updatedAt: new Date(),
        });
        updatedOwner = await this.usersRepo.updateUser(updatedUser);
      } else {
        const updatedAdmin = new Admin({
          ...owner,
          avatarUrl: dto.avatarUrl,
          updatedAt: new Date(),
        });
        updatedOwner = await this.adminsRepo.updateAdmin(updatedAdmin);
      }
    }

    // Retornar perfil actualizado
    return {
      ownerType,
      ownerId: updatedOwner.id,
      email: updatedOwner.email,
      name: updatedOwner.name,
      avatarUrl: updatedOwner.avatarUrl,
      phone: profile.phone,
      addressLine1: profile.addressLine1,
      addressLine2: profile.addressLine2,
      city: profile.city,
      postalCode: profile.postalCode,
      countryCode: profile.countryCode,
      isActive: profile.isActive,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    };
  }
}
