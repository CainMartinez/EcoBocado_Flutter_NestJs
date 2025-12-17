import { ConflictException } from '@nestjs/common';

export class DeliveryDriverAlreadyExistsException extends ConflictException {
  constructor(email: string) {
    super(`Delivery driver with email ${email} already exists`);
  }
}
