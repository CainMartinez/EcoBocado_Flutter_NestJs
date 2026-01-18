import { Injectable } from '@nestjs/common';
import { IUsersRepository } from '../../domain/repositories/users.repository';
import { PasswordHasherService } from '../../infrastructure/crypto/password-hasher.service';
import { JwtTokenService } from '../../infrastructure/token/jwt-token.service';
import { LoginRequestDto } from '../dto/request/login.request.dto';
import { UserNotFoundException } from '../../domain/exceptions/user-not-found.exception';
import { InvalidPasswordException } from '../../domain/exceptions/invalid-password.exception';
import { User } from '../../domain/entities/users.entity';

type LoginResult = {
  accessToken: string;
  refreshToken: string;
  user: User;
};

@Injectable()
export class LoginUseCase {

  constructor(
    private readonly usersRepository: IUsersRepository,
    private readonly passwordHasher: PasswordHasherService,
    private readonly jwtTokens: JwtTokenService,
  ) {}

  async execute(dto: LoginRequestDto): Promise<LoginResult> {
    const email = dto.email.trim().toLowerCase();

    const user = await this.usersRepository.findByEmail(email);
    if (!user) {
      throw new UserNotFoundException(email);
    }

    const isValid = await this.passwordHasher.verify(user.passwordHash, dto.password);
    if (!isValid) {
      throw new InvalidPasswordException();
    }

    const { token: accessToken } = await this.jwtTokens.signAccessToken(user, 'user');
    const { token: refreshToken } = await this.jwtTokens.signRefreshToken(user, 'user');

    return { accessToken, refreshToken, user };
  }
}