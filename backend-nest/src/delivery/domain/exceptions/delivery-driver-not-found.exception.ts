import { NotFoundException } from '@nestjs/common';

export class DeliveryDriverNotFoundException extends NotFoundException {
  constructor(identifier: string | number) {
    super(`Delivery driver not found: ${identifier}`);
  }
}
