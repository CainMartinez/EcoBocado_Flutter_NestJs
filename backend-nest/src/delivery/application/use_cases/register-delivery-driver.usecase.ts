import { Injectable, Logger } from '@nestjs/common';
import { IDeliveryDriverRepository } from '../../domain/repositories/delivery-driver.repository';
import { PasswordHasherService } from '../../../auth/infrastructure/crypto/password-hasher.service';
import { DeliveryRegisterRequestDto } from '../dto/request/delivery-register.request.dto';
import { DeliveryDriverAlreadyExistsException } from '../../domain/exceptions/delivery-driver-already-exists.exception';
import { v4 as uuidv4 } from 'uuid';
import { DeliveryDriver } from '../../domain/entities/delivery-driver.entity';

@Injectable()
export class RegisterDeliveryDriverUseCase {
  private readonly logger = new Logger(RegisterDeliveryDriverUseCase.name);

  constructor(
    private readonly driverRepo: IDeliveryDriverRepository,
    private readonly passwordHasher: PasswordHasherService,
  ) {}

  async execute(dto: DeliveryRegisterRequestDto): Promise<DeliveryDriver> {
    const email = dto.email.trim().toLowerCase();

    // Verificar si el email ya existe
    const existingDriver = await this.driverRepo.findByEmail(email);
    if (existingDriver) {
      throw new DeliveryDriverAlreadyExistsException(email);
    }

    // Hashear la contraseña
    const passwordHash = await this.passwordHasher.hash(dto.password);

    // Crear el repartidor
    const driver = await this.driverRepo.create({
      uuid: uuidv4(),
      email,
      name: dto.name,
      phone: dto.phone,
      passwordHash,
      avatarUrl: null,
      isActive: true,
      isAvailable: false, // Por defecto no disponible hasta que el repartidor lo active
      vehicleType: dto.vehicleType || null,
      vehiclePlate: dto.vehiclePlate || null,
      createdAt: new Date(),
      updatedAt: new Date(),
    } as any);

    this.logger.log(`Nuevo repartidor registrado: ${driver.email}`);
    return driver;
  }
}
