import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { IVenueAuthRepository } from '../../domain/repositories/venue-auth.repository';

@Injectable()
export class RestaurantJwtStrategy extends PassportStrategy(Strategy, 'restaurant-jwt') {
  constructor(private readonly venueRepo: IVenueAuthRepository) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: process.env.JWT_SECRET ?? 'dev-secret-change-me',
      issuer: process.env.JWT_ISSUER ?? 'zero-waste-api',
      audience: process.env.JWT_AUDIENCE ?? 'zero-waste-clients',
    });
  }

  async validate(payload: any) {
    if (payload.ownerType !== 'restaurant') {
      throw new UnauthorizedException('Invalid token type');
    }

    const venue = await this.venueRepo.findById(Number(payload.sub));
    if (!venue) {
      throw new UnauthorizedException('Venue not found');
    }

    if (!venue.isActive) {
      throw new UnauthorizedException('Venue account is inactive');
    }

    return {
      venueId: venue.id,
      email: venue.email,
      ownerType: 'restaurant',
    };
  }
}
