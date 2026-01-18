import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtTokenService } from '../../infrastructure/token/jwt-token.service';
import { IUsersRepository } from '../../domain/repositories/users.repository';
import { UserNotFoundException } from '../../domain/exceptions/user-not-found.exception';

type RefreshResult = {
  accessToken: string;
};

@Injectable()
export class RefreshAccessTokenUseCase {

  constructor(
    private readonly jwtTokens: JwtTokenService,
    private readonly usersRepo: IUsersRepository,
  ) {}

  /**
   * Genera un nuevo access token a partir de un refresh token válido.
   * - Solo para usuarios normales (no admins).
   * - Valida que el usuario existe y está activo.
   * - No rota tokens ni usa blacklist (eso se hace en logout).
   */
  async executeForUser(
    userId: number, 
    email?: string, 
    ownerType: 'user' | 'admin' = 'user',
  ): Promise<RefreshResult> {
    if (!email || typeof email !== 'string') {
      throw new UnauthorizedException('No se pudo determinar el usuario del token de acceso.');
    }

    const user = await this.usersRepo.findByEmail(email.toLowerCase());
    if (!user || !user.isActive || user.id !== Number(userId)) {
      throw new UserNotFoundException(email);
    }

    const { token: accessToken } = await this.jwtTokens.signAccessToken(user, ownerType);

    return { accessToken };
  }
}