import { Inject, Injectable } from '@nestjs/common';
import { USER_ADDRESS_REPOSITORY_TOKEN } from '../../domain/repositories/user-address.repository.interface';
import type { IUserAddressRepository } from '../../domain/repositories/user-address.repository.interface';
import { UserAddress } from '../../domain/entities/user-address.entity';

@Injectable()
export class UpdateUserAddressUseCase {
  constructor(
    @Inject(USER_ADDRESS_REPOSITORY_TOKEN)
    private readonly userAddressRepository: IUserAddressRepository,
  ) {}

  async execute(
    addressId: number,
    data: {
      label?: string;
      addressLine1?: string;
      addressLine2?: string;
      city?: string;
      stateProvince?: string;
      postalCode?: string;
      country?: string;
      phone?: string;
    },
  ): Promise<UserAddress> {
    return await this.userAddressRepository.update(addressId, data);
  }
}
