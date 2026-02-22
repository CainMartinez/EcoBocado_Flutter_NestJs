import { NotFoundException } from '@nestjs/common';

export class VenueNotFoundException extends NotFoundException {
  constructor(identifier: string | number) {
    super(`Venue not found: ${identifier}`);
  }
}
