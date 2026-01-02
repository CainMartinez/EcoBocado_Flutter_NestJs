import { Body, Controller, Get, Patch, Post, Req, UploadedFile, UseGuards, UseInterceptors } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiBearerAuth, ApiBody, ApiConsumes, ApiOkResponse, ApiOperation, ApiTags, ApiUnauthorizedResponse } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../../auth/presentation/guards/jwt-auth.guard';
import { GetProfileUseCase } from '../../application/use_cases/get-profile.usecase';
import { UpdateProfileUseCase } from '../../application/use_cases/update-profile.usecase';
import { UploadAvatarUseCase } from '../../application/use-cases/upload-avatar.use-case';
import { ProfileResponseDto } from '../../application/dto/response/profile.response.dto';
import { UpdateProfileRequestDto } from '../../application/dto/request/update-profile.request.dto';
import { ProfileAssembler } from '../assemblers/profile.assembler';

@ApiTags('Profile')
@ApiBearerAuth()
@Controller('profile')
export class ProfileController {
  constructor(
    private readonly getProfile: GetProfileUseCase,
    private readonly updateProfile: UpdateProfileUseCase,
    private readonly uploadAvatar: UploadAvatarUseCase,
    private readonly profileAssembler: ProfileAssembler,
  ) {}

  @Get('me')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({ summary: 'Obtener el perfil del usuario/admin autenticado' })
  @ApiOkResponse({ description: 'Perfil encontrado', type: ProfileResponseDto })
  @ApiUnauthorizedResponse({ description: 'Token inválido o revocado' })
  async me(@Req() req: any): Promise<ProfileResponseDto> {
    const email: string = req.user?.email;
    const ownerType: 'user' | 'admin' = req.user?.ownerType || 'user';

    return this.getProfile.execute(ownerType, email);
  }

  @Patch('update')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({ summary: 'Actualizar el perfil del usuario/admin autenticado' })
  @ApiOkResponse({ description: 'Perfil actualizado correctamente', type: ProfileResponseDto })
  @ApiUnauthorizedResponse({ description: 'Token inválido o revocado' })
  async updateMe(@Req() req: any, @Body() dto: UpdateProfileRequestDto): Promise<ProfileResponseDto> {
    const email: string = req.user?.email;
    const ownerType: 'user' | 'admin' = req.user?.ownerType || 'user';

    return this.updateProfile.execute(ownerType, email, dto);
  }

  @Post('avatar')
  @UseGuards(JwtAuthGuard)
  @UseInterceptors(FileInterceptor('file'))
  @ApiOperation({ summary: 'Subir o actualizar foto de perfil' })
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        file: {
          type: 'string',
          format: 'binary',
        },
      },
    },
  })
  @ApiOkResponse({ description: 'Avatar actualizado correctamente', type: ProfileResponseDto })
  @ApiUnauthorizedResponse({ description: 'Token inválido o revocado' })
  async uploadAvatarImage(
    @Req() req: any,
    @UploadedFile() file: Express.Multer.File,
  ): Promise<ProfileResponseDto> {
    const email: string = req.user?.email;
    const ownerType: 'user' | 'admin' = req.user?.ownerType || 'user';
    const ownerId: number = req.user?.id;

    const profile = await this.uploadAvatar.execute(ownerType, ownerId, file);
    return this.profileAssembler.toDto(profile, email, req.user?.name);
  }
}