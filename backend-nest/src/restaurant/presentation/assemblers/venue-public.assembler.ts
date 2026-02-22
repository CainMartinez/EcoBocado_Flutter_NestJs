import { Injectable } from '@nestjs/common';
import { Venue } from '../../../locations/domain/entities/venue.entity';

@Injectable()
export class VenuePublicAssembler {
  toPublic(venue: Venue) {
    return {
      id: venue.id,
      uuid: venue.uuid,
      code: venue.code,
      email: venue.email,
      name: venue.name,
      phone: venue.phone,
      avatarUrl: venue.avatarUrl,
      timezone: venue.timezone,
    };
  }
}
