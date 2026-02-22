import { Injectable } from '@nestjs/common';
import { IVenueAuthRepository } from '../../domain/repositories/venue-auth.repository';
import { VenueNotFoundException } from '../../domain/exceptions/venue-not-found.exception';

@Injectable()
export class GetRestaurantProfileUseCase {
  constructor(private readonly venueRepo: IVenueAuthRepository) {}

  async execute(venueId: number) {
    const venue = await this.venueRepo.findById(venueId);
    if (!venue) {
      throw new VenueNotFoundException(venueId);
    }
    return venue;
  }
}
