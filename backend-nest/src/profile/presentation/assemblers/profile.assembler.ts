import { Injectable } from '@nestjs/common';
import { ProfileResponseDto } from '../../application/dto/response/profile.response.dto';
import { Profile } from '../../domain/entities/profile.entity';
import { User } from '../../../auth/domain/entities/users.entity';
import { Admin } from '../../../auth/domain/entities/admins.entity';

@Injectable()
export class ProfileAssembler {
  /**
   * Convierte un Profile y datos del owner a ProfileResponseDto
   */
  toDto(profile: Profile, email: string, name: string): ProfileResponseDto {
    const dto = new ProfileResponseDto();
    dto.ownerType = profile.ownerType;
    dto.ownerId = profile.ownerId;
    dto.email = email;
    dto.name = name;
    dto.avatarUrl = profile.avatarUrl;
    dto.phone = profile.phone;
    dto.addressLine1 = profile.addressLine1;
    dto.addressLine2 = profile.addressLine2;
    dto.city = profile.city;
    dto.postalCode = profile.postalCode;
    dto.countryCode = profile.countryCode;
    dto.isActive = profile.isActive;
    dto.createdAt = profile.createdAt;
    dto.updatedAt = profile.updatedAt;
    return dto;
  }

  toDtoFromUser(user: User, profile: Profile | null): ProfileResponseDto {
    const dto = new ProfileResponseDto();
    dto.ownerType = 'user';
    dto.ownerId = user.id;
    dto.email = user.email;
    dto.name = user.name;
    dto.avatarUrl = profile?.avatarUrl ?? null;
    dto.phone = profile?.phone ?? null;
    dto.addressLine1 = profile?.addressLine1 ?? null;
    dto.addressLine2 = profile?.addressLine2 ?? null;
    dto.city = profile?.city ?? null;
    dto.postalCode = profile?.postalCode ?? null;
    dto.countryCode = profile?.countryCode ?? 'ES';
    dto.isActive = profile ? profile.isActive : user.isActive;
    dto.createdAt = profile ? profile.createdAt : user.createdAt;
    dto.updatedAt = profile ? profile.updatedAt : user.updatedAt;
    return dto;
  }

  toDtoFromAdmin(admin: Admin, profile: Profile | null = null): ProfileResponseDto {
    const dto = new ProfileResponseDto();
    dto.ownerType = 'admin';
    dto.ownerId = admin.id;
    dto.email = admin.email;
    dto.name = admin.name;
    dto.avatarUrl = profile?.avatarUrl ?? null;
    dto.phone = profile?.phone ?? null;
    dto.addressLine1 = null;
    dto.addressLine2 = null;
    dto.city = null;
    dto.postalCode = null;
    dto.countryCode = 'ES';
    dto.isActive = admin.isActive;
    dto.createdAt = admin.createdAt;
    dto.updatedAt = admin.updatedAt;
    return dto;
  }
}