import { Injectable, Logger } from '@nestjs/common';
import { IDeliveryDriverRepository } from '../../domain/repositories/delivery-driver.repository';
import { PasswordHasherService } from '../../../auth/infrastructure/crypto/password-hasher.service';
import { DeliveryJwtTokenService } from '../../infrastructure/token/delivery-jwt-token.service';
import { DeliveryLoginRequestDto } from '../dto/request/delivery-login.request.dto';
import { DeliveryDriverNotFoundException } from '../../domain/exceptions/delivery-driver-not-found.exception';
import { InvalidPasswordException } from '../../domain/exceptions/invalid-password.exception';
import { DeliveryDriver } from '../../domain/entities/delivery-driver.entity';

type DeliveryLoginResult = {
  accessToken: string;
  expiresIn: number;
  driver: DeliveryDriver;
};

@Injectable()
export class DeliveryLoginUseCase {
  private readonly logger = new Logger(DeliveryLoginUseCase.name);

  constructor(
    private readonly driverRepo: IDeliveryDriverRepository,
    private readonly passwordHasher: PasswordHasherService,
    private readonly jwtTokens: DeliveryJwtTokenService,
  ) {}

  async execute(dto: DeliveryLoginRequestDto): Promise<DeliveryLoginResult> {
    const email = dto.email.trim().toLowerCase();

    const driver = await this.driverRepo.findByEmail(email);
    if (!driver) {
      throw new DeliveryDriverNotFoundException(email);
    }

    const isValid = await this.passwordHasher.verify(driver.passwordHash, dto.password);
    if (!isValid) {
      throw new InvalidPasswordException();
    }

    if (!driver.isActive) {
      throw new DeliveryDriverNotFoundException(email);
    }

    const { token: accessToken, exp } = await this.jwtTokens.signAccessToken(driver);

    this.logger.log(`Login correcto para repartidor: ${driver.email}`);
    return { accessToken, expiresIn: exp, driver };
  }
}
