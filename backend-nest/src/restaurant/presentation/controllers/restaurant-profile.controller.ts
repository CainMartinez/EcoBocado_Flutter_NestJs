import { Controller, Get, Post, UseGuards, Request, UploadedFile, UseInterceptors } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiTags, ApiOperation, ApiOkResponse, ApiUnauthorizedResponse, ApiBearerAuth, ApiConsumes, ApiBody } from '@nestjs/swagger';
import { RestaurantJwtAuthGuard } from '../guards/restaurant-jwt-auth.guard';
import { GetRestaurantProfileUseCase } from '../../application/use_cases/get-restaurant-profile.usecase';
import { UploadRestaurantAvatarUseCase } from '../../application/use_cases/upload-restaurant-avatar.usecase';
import { VenuePublicAssembler } from '../assemblers/venue-public.assembler';

/**
 * Controlador de perfil del restaurante
 */
@ApiTags('Restaurant - Perfil')
@Controller('restaurant/profile')
@UseGuards(RestaurantJwtAuthGuard)
@ApiBearerAuth()
export class RestaurantProfileController {
  constructor(
    private readonly getProfileUseCase: GetRestaurantProfileUseCase,
    private readonly uploadAvatarUseCase: UploadRestaurantAvatarUseCase,
    private readonly assembler: VenuePublicAssembler,
  ) {}

  @Get('me')
  @ApiOperation({ summary: 'Obtener perfil del restaurante' })
  @ApiOkResponse({ description: 'Perfil del restaurante obtenido exitosamente' })
  @ApiUnauthorizedResponse({ description: 'Token inválido o expirado' })
  async getProfile(@Request() req: any) {
    const venue = await this.getProfileUseCase.execute(req.user.venueId);
    return this.assembler.toPublic(venue);
  }

  @Post('avatar')
  @UseInterceptors(FileInterceptor('file'))
  @ApiOperation({ summary: 'Subir o actualizar foto de perfil del restaurante' })
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      properties: { file: { type: 'string', format: 'binary' } },
    },
  })
  @ApiOkResponse({ description: 'Avatar actualizado correctamente' })
  @ApiUnauthorizedResponse({ description: 'Token inválido o expirado' })
  async uploadAvatar(
    @Request() req: any,
    @UploadedFile() file: Express.Multer.File,
  ) {
    const venue = await this.uploadAvatarUseCase.execute(req.user.venueId, file);
    return this.assembler.toPublic(venue);
  }
}
