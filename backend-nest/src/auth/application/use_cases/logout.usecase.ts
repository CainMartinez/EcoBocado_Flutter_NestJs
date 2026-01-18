import { Injectable } from '@nestjs/common';
import { IJwtBlacklistRepository } from '../../domain/repositories/jwt-blacklist.repository';
import { JwtBlacklistEntry } from '../../domain/entities/blacklist.entity';
import { JwtTokenService } from '../../infrastructure/token/jwt-token.service';

/**
 * Caso de uso: Logout del usuario autenticado.
 * - Revoca el access token actual añadiéndolo a la blacklist.
 * - Opcionalmente revoca también el refresh token si se proporciona.
 */
@Injectable()
export class LogoutUseCase {

  constructor(
    private readonly blacklistRepo: IJwtBlacklistRepository,
    private readonly jwtTokens: JwtTokenService,
  ) {}

  /**
   * Ejecuta el proceso de logout.
   * @param params datos extraídos del access token y opcionalmente refresh token
   */
  async execute(params: {
    jti: string;
    userId: number;
    token: string;
    exp: number;
    refreshToken?: string;
  }): Promise<void> {
    const expiresAt = new Date(params.exp * 1000);

    // Añadir access token a la blacklist
    const accessEntry = new JwtBlacklistEntry({
      jti: params.jti,
      userId: params.userId,
      token: params.token,
      issuedAt: new Date(),
      expiresAt,
      revokedAt: new Date(),
      reason: 'logout',
    });

    await this.blacklistRepo.add(accessEntry);

    // Si se proporciona refresh token, también revocarlo
    if (params.refreshToken) {
      try {
        const refreshPayload = await this.jwtTokens.verify(params.refreshToken);
        
        const refreshEntry = new JwtBlacklistEntry({
          jti: refreshPayload.jti,
          userId: params.userId,
          token: params.refreshToken,
          issuedAt: new Date(),
          expiresAt: new Date(refreshPayload.exp * 1000),
          revokedAt: new Date(),
          reason: 'logout',
        });

        await this.blacklistRepo.add(refreshEntry);
      } catch (error) {
        // Si el refresh token es inválido, lo ignoramos (puede estar expirado)
      }
    }

  }
}