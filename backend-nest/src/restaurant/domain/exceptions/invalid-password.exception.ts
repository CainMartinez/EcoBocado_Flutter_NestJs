import { UnauthorizedException } from '@nestjs/common';

export class InvalidPasswordException extends UnauthorizedException {
  constructor() {
    super('Invalid password');
  }
}
