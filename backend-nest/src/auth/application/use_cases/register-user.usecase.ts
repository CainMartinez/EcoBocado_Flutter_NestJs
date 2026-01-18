import { Injectable } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';

import { IUsersRepository } from '../../domain/repositories/users.repository';
import { PasswordHasherService } from '../../infrastructure/crypto/password-hasher.service';
import { RegisterUserRequestDto } from '../dto/request/register-user.request.dto';

import { EmailAlreadyInUseException } from '../../domain/exceptions/email-already-in-use.exception';
import { WeakPasswordException } from '../../domain/exceptions/weak-password.exception';
import { User } from '../../domain/entities/users.entity';

@Injectable()
export class RegisterUserUseCase {

  constructor(
    private readonly usersRepository: IUsersRepository,
    private readonly passwordHasher: PasswordHasherService,
  ) {}

  /**
   * Orquesta el registro y devuelve la entidad de dominio.
   * El controller mapeará a DTO con el assembler.
   */
  async execute(dto: RegisterUserRequestDto): Promise<User> {
    const email = dto.email.trim().toLowerCase();

    // 1) Verificar duplicado
    if (await this.usersRepository.existsByEmail(email)) {
      throw new EmailAlreadyInUseException(email);
    }

    // 2) Validar fuerza de contraseña (complementa a class-validator)
    if (!this.isPasswordStrong(dto.password)) {
      throw new WeakPasswordException({
        minLength: 8,
        requiresUpper: true,
        requiresLower: true,
        requiresDigit: true,
      });
    }

    // 3) Hashear contraseña
    const passwordHash = await this.passwordHasher.hash(dto.password);

    // 4) Crear entidad de dominio
    const avatarUrl = `https://i.pravatar.cc/200?u=${encodeURIComponent(dto.name.trim())}`;

    const user = new User({
      id: 0,
      uuid: uuidv4(),
      email,
      name: dto.name.trim(),
      passwordHash,
      avatarUrl,
      isActive: true,
      createdAt: new Date(),
      updatedAt: new Date(),
    });

    // 5) Persistir
    const saved = await this.usersRepository.createUser(user);

    return saved; // ← devuelve dominio; el controller lo transforma a DTO
  }

  private isPasswordStrong(password: string): boolean {
    return /(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}/.test(password);
  }
}