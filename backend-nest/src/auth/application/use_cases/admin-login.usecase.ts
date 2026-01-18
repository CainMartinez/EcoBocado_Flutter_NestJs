import { Injectable } from '@nestjs/common';
import { IAdminsRepository } from '../../domain/repositories/admin.repository';
import { PasswordHasherService } from '../../infrastructure/crypto/password-hasher.service';
import { JwtTokenService } from '../../infrastructure/token/jwt-token.service';
import { AdminLoginRequestDto } from '../dto/request/admin-login.request.dto';
import { InvalidPasswordException } from '../../domain/exceptions/invalid-password.exception';
import { UserNotFoundException } from '../../domain/exceptions/user-not-found.exception';
import { Admin } from '../../domain/entities/admins.entity';

type AdminLoginResult = {
  accessToken: string;
  admin: Admin;
};

/**
 * Autenticación de administrador (sin refresh token).
 */
@Injectable()
export class AdminLoginUseCase {

  constructor(
    private readonly adminsRepo: IAdminsRepository,
    private readonly passwordHasher: PasswordHasherService,
    private readonly jwtTokens: JwtTokenService,
  ) {}

  async execute(dto: AdminLoginRequestDto): Promise<AdminLoginResult> {
    const email = dto.email.trim().toLowerCase();

    const admin = await this.adminsRepo.findByEmail(email);
    if (!admin || !admin.isActive) {
      throw new UserNotFoundException(email);
    }

    const ok = await this.passwordHasher.verify(admin.passwordHash, dto.password);
    if (!ok) {
      throw new InvalidPasswordException();
    }

    // Emite access token de corta duración para admin
    const { token: accessToken } = await this.jwtTokens.signAccessToken({
      id: admin.id,
      email: admin.email,
      name: admin.name,
      passwordHash: admin.passwordHash,
      avatarUrl: admin.avatarUrl,
      isActive: admin.isActive,
      createdAt: admin.createdAt,
      updatedAt: admin.updatedAt,
    } as any, 'admin');

    return { accessToken, admin };
  }
}