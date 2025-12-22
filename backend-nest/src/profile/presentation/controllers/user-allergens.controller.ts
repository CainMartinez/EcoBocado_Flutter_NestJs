import {
  Controller,
  Post,
  Delete,
  Get,
  Param,
  UseGuards,
  Request,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth, ApiParam } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../../auth/presentation/guards/jwt-auth.guard';
import { AddUserAllergenUseCase } from '../../application/use-cases/add-user-allergen.use-case';
import { RemoveUserAllergenUseCase } from '../../application/use-cases/remove-user-allergen.use-case';
import { GetUserAllergensUseCase } from '../../application/use-cases/get-user-allergens.use-case';

@ApiTags('User Allergens')
@ApiBearerAuth()
@Controller('profile/allergens')
@UseGuards(JwtAuthGuard)
export class UserAllergensController {
  constructor(
    private readonly addUserAllergenUseCase: AddUserAllergenUseCase,
    private readonly removeUserAllergenUseCase: RemoveUserAllergenUseCase,
    private readonly getUserAllergensUseCase: GetUserAllergensUseCase,
  ) {}

  @Get()
  @ApiOperation({ summary: 'Obtener los alérgenos del usuario' })
  @ApiResponse({ status: 200, description: 'Lista de códigos de alérgenos del usuario', type: [String] })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async getUserAllergens(@Request() req): Promise<string[]> {
    const userId = parseInt(req.user.sub);
    return await this.getUserAllergensUseCase.execute(userId);
  }

  @Post(':allergenCode')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Agregar un alérgeno al perfil del usuario' })
  @ApiParam({ name: 'allergenCode', description: 'Código del alérgeno (ej: gluten, lactose)' })
  @ApiResponse({ status: 204, description: 'Alérgeno agregado exitosamente' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async addAllergen(
    @Request() req,
    @Param('allergenCode') allergenCode: string,
  ): Promise<void> {
    const userId = parseInt(req.user.sub);
    await this.addUserAllergenUseCase.execute(userId, allergenCode);
  }

  @Delete(':allergenCode')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Eliminar un alérgeno del perfil del usuario' })
  @ApiParam({ name: 'allergenCode', description: 'Código del alérgeno' })
  @ApiResponse({ status: 204, description: 'Alérgeno eliminado exitosamente' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async removeAllergen(
    @Request() req,
    @Param('allergenCode') allergenCode: string,
  ): Promise<void> {
    const userId = parseInt(req.user.sub);
    await this.removeUserAllergenUseCase.execute(userId, allergenCode);
  }
}
