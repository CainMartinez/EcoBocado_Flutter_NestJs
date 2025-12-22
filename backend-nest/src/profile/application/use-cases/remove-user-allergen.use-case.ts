import { Inject, Injectable } from '@nestjs/common';
import { USER_ALLERGEN_REPOSITORY_TOKEN } from '../../domain/repositories/user-allergen.repository.interface';
import type { IUserAllergenRepository } from '../../domain/repositories/user-allergen.repository.interface';

@Injectable()
export class RemoveUserAllergenUseCase {
  constructor(
    @Inject(USER_ALLERGEN_REPOSITORY_TOKEN)
    private readonly userAllergenRepository: IUserAllergenRepository,
  ) {}

  async execute(userId: number, allergenCode: string): Promise<void> {
    await this.userAllergenRepository.remove(userId, allergenCode);
  }
}
