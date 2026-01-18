import { Injectable, UnauthorizedException } from '@nestjs/common';
import { IJwtBlacklistRepository } from '../../domain/repositories/jwt-blacklist.repository';
import { JwtTokenService } from '../../infrastructure/token/jwt-token.service';
import { JwtBlacklistEntry } from '../../domain/entities/blacklist.entity';

/**
 * Cierre de sesión para administradores (sin refresh).
 * Verifica el access token recibido y lo añade a la blacklist.
 */
@Injectable()
export class AdminLogoutUseCase {

  constructor(
    private readonly blacklistRepo: IJwtBlacklistRepository,
    private readonly jwtTokens: JwtTokenService,
  ) {}

  /**
   * Revoca el access token actual del admin añadiéndolo a la blacklist.
   * Requiere el token bruto (Bearer) y el userId del sujeto autenticado.
   */
  async execute(params: { userId: number; token: string }): Promise<void> {
    if (!params.token) {
      throw new UnauthorizedException('Falta el token de acceso.');
    }

    // Verifica firma/claims y extrae jti/exp/email/sub
    const payload = await this.safeVerify(params.token);
    const jti = String((payload as any).jti ?? '');
    const exp = Number((payload as any).exp ?? 0);

    if (!jti || !exp) {
      throw new UnauthorizedException('Token sin claims obligatorios.');
    }

    const entry = new JwtBlacklistEntry({
      jti,
      userId: params.userId,
      token: params.token,
      issuedAt: new Date(),
      expiresAt: new Date(exp * 1000),
      revokedAt: new Date(),
      reason: 'admin_logout',
    });

    await this.blacklistRepo.add(entry);
  }

  private async safeVerify(token: string): Promise<unknown> {
    try {
      return await this.jwtTokens.verify(token);
    } catch {
      throw new UnauthorizedException('Token de acceso inválido o caducado.');
    }
  }
}