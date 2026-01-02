import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProfileOrmEntity } from './infrastructure/typeorm/entities-orm/profile.orm-entity';
import { UserAddressOrmEntity } from './infrastructure/typeorm/entities-orm/user-address.orm-entity';
import { UserAllergenOrmEntity } from './infrastructure/typeorm/entities-orm/user-allergen.orm-entity';
import { ProfileController } from './presentation/controllers/profile.controller';
import { UserAddressesController } from './presentation/controllers/user-addresses.controller';
import { UserAllergensController } from './presentation/controllers/user-allergens.controller';
import { GetProfileUseCase } from './application/use_cases/get-profile.usecase';
import { UpdateProfileUseCase } from './application/use_cases/update-profile.usecase';
import { UploadAvatarUseCase } from './application/use-cases/upload-avatar.use-case';
import { CreateUserAddressUseCase } from './application/use-cases/create-user-address.use-case';
import { GetUserAddressesUseCase } from './application/use-cases/get-user-addresses.use-case';
import { UpdateUserAddressUseCase } from './application/use-cases/update-user-address.use-case';
import { DeleteUserAddressUseCase } from './application/use-cases/delete-user-address.use-case';
import { SetDefaultAddressUseCase } from './application/use-cases/set-default-address.use-case';
import { AddUserAllergenUseCase } from './application/use-cases/add-user-allergen.use-case';
import { RemoveUserAllergenUseCase } from './application/use-cases/remove-user-allergen.use-case';
import { GetUserAllergensUseCase } from './application/use-cases/get-user-allergens.use-case';
import { ProfilesTypeOrmRepository } from './infrastructure/typeorm/repositories/profile.typeorm.repository';
import { TypeOrmUserAddressRepository } from './infrastructure/typeorm/repositories/typeorm-user-address.repository';
import { TypeOrmUserAllergenRepository } from './infrastructure/typeorm/repositories/typeorm-user-allergen.repository';
import { IProfilesRepository } from './domain/repositories/profile.repository';
import { USER_ADDRESS_REPOSITORY_TOKEN } from './domain/repositories/user-address.repository.interface';
import { USER_ALLERGEN_REPOSITORY_TOKEN } from './domain/repositories/user-allergen.repository.interface';
import { AuthModule } from '../auth/auth.module';
import { MediaModule } from '../media/media.module';
import { ProfileAssembler } from './presentation/assemblers/profile.assembler';

@Module({
  imports: [
    TypeOrmModule.forFeature([ProfileOrmEntity, UserAddressOrmEntity, UserAllergenOrmEntity]),
    AuthModule,
    MediaModule,
  ],
  controllers: [ProfileController, UserAddressesController, UserAllergensController],
  providers: [
    GetProfileUseCase,
    UpdateProfileUseCase,
    UploadAvatarUseCase,
    ProfileAssembler,
    CreateUserAddressUseCase,
    GetUserAddressesUseCase,
    UpdateUserAddressUseCase,
    DeleteUserAddressUseCase,
    SetDefaultAddressUseCase,
    AddUserAllergenUseCase,
    RemoveUserAllergenUseCase,
    GetUserAllergensUseCase,
    ProfilesTypeOrmRepository,
    {
      provide: IProfilesRepository,
      useExisting: ProfilesTypeOrmRepository,
    },
    {
      provide: USER_ADDRESS_REPOSITORY_TOKEN,
      useClass: TypeOrmUserAddressRepository,
    },
    {
      provide: USER_ALLERGEN_REPOSITORY_TOKEN,
      useClass: TypeOrmUserAllergenRepository,
    },
  ],
  exports: [USER_ADDRESS_REPOSITORY_TOKEN, USER_ALLERGEN_REPOSITORY_TOKEN],
})
export class ProfileModule {}