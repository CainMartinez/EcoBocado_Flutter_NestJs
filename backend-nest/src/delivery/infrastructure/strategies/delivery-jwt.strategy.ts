import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { IDeliveryDriverRepository } from '../../domain/repositories/delivery-driver.repository';

@Injectable()
export class DeliveryJwtStrategy extends PassportStrategy(Strategy, 'delivery-jwt') {
  constructor(private readonly driverRepo: IDeliveryDriverRepository) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: process.env.JWT_SECRET ?? 'dev-secret-change-me',
      issuer: process.env.JWT_ISSUER ?? 'zero-waste-api',
      audience: process.env.JWT_AUDIENCE ?? 'zero-waste-clients',
    });
  }

  async validate(payload: any) {
    // Validar que el token sea de tipo delivery
    if (payload.ownerType !== 'delivery') {
      throw new UnauthorizedException('Invalid token type');
    }

    const driver = await this.driverRepo.findById(Number(payload.sub));
    if (!driver) {
      throw new UnauthorizedException('Driver not found');
    }

    if (!driver.isActive) {
      throw new UnauthorizedException('Driver account is inactive');
    }

    return {
      driverId: driver.id,
      email: driver.email,
      ownerType: 'delivery',
    };
  }
}
