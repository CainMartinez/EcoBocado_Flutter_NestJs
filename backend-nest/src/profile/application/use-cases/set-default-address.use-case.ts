import { Inject, Injectable } from '@nestjs/common';
import { USER_ADDRESS_REPOSITORY_TOKEN } from '../../domain/repositories/user-address.repository.interface';
import type { IUserAddressRepository } from '../../domain/repositories/user-address.repository.interface';

@Injectable()
export class SetDefaultAddressUseCase {
  constructor(
    @Inject(USER_ADDRESS_REPOSITORY_TOKEN)
    private readonly userAddressRepository: IUserAddressRepository,
  ) {}

  async execute(userId: number, addressId: number): Promise<void> {
    await this.userAddressRepository.setAsDefault(userId, addressId);
  }
}
