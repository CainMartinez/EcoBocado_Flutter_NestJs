import { Injectable } from '@nestjs/common';
import { JwtService, JwtSignOptions } from '@nestjs/jwt';
import { v4 as uuidv4 } from 'uuid';
import type { StringValue as MsStringValue } from 'ms';
import { User } from '../../domain/entities/users.entity';

@Injectable()
export class JwtTokenService {
  constructor(private readonly jwt: JwtService) {}

  private get issuer()  { return process.env.JWT_ISSUER   || 'zero-waste-api'; }
  private get audience(){ return process.env.JWT_AUDIENCE || 'zero-waste-clients'; }

  // helper que convierte env a number | ms.StringValue
  private parseExpires(input: string | undefined, def: MsStringValue): number | MsStringValue {
    if (!input) return def;                                // default tipado como MsStringValue
    if (/^\d+$/.test(input)) return Number(input);         // 900 (segundos)
    return input as MsStringValue;                         // "15m" access | "7d" refresh
  }

  private get accessTtl(): number | MsStringValue {
    return this.parseExpires(process.env.JWT_EXPIRES_IN, '1d' as MsStringValue);
  }
  private get refreshTtl(): number | MsStringValue {
    return this.parseExpires(process.env.JWT_REFRESH_EXPIRES_IN, '7d' as MsStringValue);
  }

    async signAccessToken(user: User, ownerType: 'user' | 'admin' = 'user'): Promise<{ token: string; jti: string; exp: number }> {
        const jti = uuidv4();

        const payload = {
            email: user.email,
            ownerType,
            jti,
            typ: 'access',
        };

        const opts: JwtSignOptions = {
            issuer: this.issuer,
            audience: this.audience,
            subject: String(user.id),
            expiresIn: this.accessTtl,
        };

        const token = await this.jwt.signAsync(payload, opts);
        return { token, jti, exp: this.decodeExp(token) };
    }

    async signRefreshToken(user: User, ownerType: 'user' | 'admin' = 'user'): Promise<{ token: string; jti: string; exp: number }> {
        const jti = uuidv4();

        const payload = {
            email: user.email,
            ownerType,
            jti,
            typ: 'refresh',
        };

        const opts: JwtSignOptions = {
            issuer: this.issuer,
            audience: this.audience,
            subject: String(user.id),
            expiresIn: this.refreshTtl,
        };

        const token = await this.jwt.signAsync(payload, opts);
        return { token, jti, exp: this.decodeExp(token) };
    }

  async verify(token: string) {
    return this.jwt.verifyAsync(token, { issuer: this.issuer, audience: this.audience });
  }

  private decodeExp(token: string): number {
    const [, payloadB64] = token.split('.');
    const json = Buffer.from(payloadB64, 'base64').toString('utf8');
    return (JSON.parse(json) as { exp: number }).exp;
  }
}