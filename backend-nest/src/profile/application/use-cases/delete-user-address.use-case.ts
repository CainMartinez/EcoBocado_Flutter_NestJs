import { Inject, Injectable } from '@nestjs/common';
import { USER_ADDRESS_REPOSITORY_TOKEN } from '../../domain/repositories/user-address.repository.interface';
import type { IUserAddressRepository } from '../../domain/repositories/user-address.repository.interface';

@Injectable()
export class DeleteUserAddressUseCase {
  constructor(
    @Inject(USER_ADDRESS_REPOSITORY_TOKEN)
    private readonly userAddressRepository: IUserAddressRepository,
  ) {}

  async execute(addressId: number): Promise<void> {
    await this.userAddressRepository.delete(addressId);
  }
}
