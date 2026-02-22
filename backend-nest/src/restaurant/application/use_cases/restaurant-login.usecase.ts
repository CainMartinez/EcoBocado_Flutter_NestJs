import { Injectable } from '@nestjs/common';
import { IVenueAuthRepository } from '../../domain/repositories/venue-auth.repository';
import { PasswordHasherService } from '../../../auth/infrastructure/crypto/password-hasher.service';
import { RestaurantJwtTokenService } from '../../infrastructure/token/restaurant-jwt-token.service';
import { RestaurantLoginRequestDto } from '../dto/request/restaurant-login.request.dto';
import { VenueNotFoundException } from '../../domain/exceptions/venue-not-found.exception';
import { InvalidPasswordException } from '../../domain/exceptions/invalid-password.exception';
import { Venue } from '../../../locations/domain/entities/venue.entity';

type RestaurantLoginResult = {
  accessToken: string;
  expiresIn: number;
  venue: Venue;
};

@Injectable()
export class RestaurantLoginUseCase {
  constructor(
    private readonly venueRepo: IVenueAuthRepository,
    private readonly passwordHasher: PasswordHasherService,
    private readonly jwtTokens: RestaurantJwtTokenService,
  ) {}

  async execute(dto: RestaurantLoginRequestDto): Promise<RestaurantLoginResult> {
    const email = dto.email.trim().toLowerCase();

    const venue = await this.venueRepo.findByEmail(email);
    if (!venue) {
      throw new VenueNotFoundException(email);
    }

    if (!venue.passwordHash) {
      throw new VenueNotFoundException(email);
    }

    const isValid = await this.passwordHasher.verify(venue.passwordHash, dto.password);
    if (!isValid) {
      throw new InvalidPasswordException();
    }

    if (!venue.isActive) {
      throw new VenueNotFoundException(email);
    }

    const { token: accessToken, exp } = await this.jwtTokens.signAccessToken(venue);

    return { accessToken, expiresIn: exp, venue };
  }
}
