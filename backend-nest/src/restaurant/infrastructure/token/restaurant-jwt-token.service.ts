import { Injectable } from '@nestjs/common';
import { JwtService, JwtSignOptions } from '@nestjs/jwt';
import { v4 as uuidv4 } from 'uuid';
import { Venue } from '../../../locations/domain/entities/venue.entity';

@Injectable()
export class RestaurantJwtTokenService {
  constructor(private readonly jwt: JwtService) {}

  private get issuer() {
    return process.env.JWT_ISSUER || 'zero-waste-api';
  }
  private get audience() {
    return process.env.JWT_AUDIENCE || 'zero-waste-clients';
  }

  /**
   * Token de 8 horas para empleados del restaurante (sin refresh token)
   */
  async signAccessToken(venue: Venue): Promise<{ token: string; jti: string; exp: number }> {
    const jti = uuidv4();

    const payload = {
      email: venue.email,
      ownerType: 'restaurant',
      jti,
      typ: 'access',
    };

    const opts: JwtSignOptions = {
      issuer: this.issuer,
      audience: this.audience,
      subject: String(venue.id),
      expiresIn: '8h',
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
