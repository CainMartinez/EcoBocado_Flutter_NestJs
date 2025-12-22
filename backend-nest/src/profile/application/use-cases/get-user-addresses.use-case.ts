import { Inject, Injectable } from '@nestjs/common';
import { USER_ADDRESS_REPOSITORY_TOKEN } from '../../domain/repositories/user-address.repository.interface';
import type { IUserAddressRepository } from '../../domain/repositories/user-address.repository.interface';
import { UserAddress } from '../../domain/entities/user-address.entity';

@Injectable()
export class GetUserAddressesUseCase {
  constructor(
    @Inject(USER_ADDRESS_REPOSITORY_TOKEN)
    private readonly userAddressRepository: IUserAddressRepository,
  ) {}

  async execute(userId: number): Promise<UserAddress[]> {
    return await this.userAddressRepository.findByUserId(userId);
  }
}
