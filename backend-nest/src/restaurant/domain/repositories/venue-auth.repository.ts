import { Venue } from '../../../locations/domain/entities/venue.entity';

export abstract class IVenueAuthRepository {
  abstract findById(id: number): Promise<Venue | null>;
  abstract findByEmail(email: string): Promise<Venue | null>;
  abstract update(id: number, data: Partial<Venue>): Promise<Venue>;
}
