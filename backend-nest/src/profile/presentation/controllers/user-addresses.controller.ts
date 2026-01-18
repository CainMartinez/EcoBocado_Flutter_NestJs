import {
  Controller,
  Post,
  Get,
  Put,
  Delete,
  Patch,
  Body,
  Param,
  UseGuards,
  Request,
  HttpCode,
  HttpStatus
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth, ApiParam } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../../auth/presentation/guards/jwt-auth.guard';
import { CreateUserAddressUseCase } from '../../application/use-cases/create-user-address.use-case';
import { GetUserAddressesUseCase } from '../../application/use-cases/get-user-addresses.use-case';
import { UpdateUserAddressUseCase } from '../../application/use-cases/update-user-address.use-case';
import { DeleteUserAddressUseCase } from '../../application/use-cases/delete-user-address.use-case';
import { SetDefaultAddressUseCase } from '../../application/use-cases/set-default-address.use-case';
import { CreateUserAddressRequestDto } from '../../application/dto/request/create-user-address.request.dto';
import { UpdateUserAddressRequestDto } from '../../application/dto/request/update-user-address.request.dto';
import { UserAddressResponseDto } from '../../application/dto/response/user-address.response.dto';

@ApiTags('User Addresses')
@ApiBearerAuth()
@Controller('profile/addresses')
@UseGuards(JwtAuthGuard)
export class UserAddressesController {

  constructor(
    private readonly createUserAddressUseCase: CreateUserAddressUseCase,
    private readonly getUserAddressesUseCase: GetUserAddressesUseCase,
    private readonly updateUserAddressUseCase: UpdateUserAddressUseCase,
    private readonly deleteUserAddressUseCase: DeleteUserAddressUseCase,
    private readonly setDefaultAddressUseCase: SetDefaultAddressUseCase,
  ) {}

  @Post()
  @ApiOperation({ summary: 'Crear una nueva dirección de entrega' })
  @ApiResponse({ status: 201, description: 'Dirección creada exitosamente', type: UserAddressResponseDto })
  @ApiResponse({ status: 400, description: 'Datos inválidos' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async create(
    @Request() req,
    @Body() dto: CreateUserAddressRequestDto,
  ): Promise<UserAddressResponseDto> {
    const userId = parseInt(req.user.sub);
    
    const address = await this.createUserAddressUseCase.execute(userId, dto);
    
    return {
      id: address.id,
      userId: address.userId,
      label: address.label,
      addressLine1: address.addressLine1,
      addressLine2: address.addressLine2,
      city: address.city,
      stateProvince: address.stateProvince,
      postalCode: address.postalCode,
      country: address.country,
      phone: address.phone,
      isDefault: address.isDefault,
      isActive: address.isActive,
      createdAt: address.createdAt,
      updatedAt: address.updatedAt,
    };
  }

  @Get()
  @ApiOperation({ summary: 'Obtener todas las direcciones del usuario' })
  @ApiResponse({ status: 200, description: 'Lista de direcciones', type: [UserAddressResponseDto] })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async findAll(@Request() req): Promise<UserAddressResponseDto[]> {
    const userId = parseInt(req.user.sub);
    const addresses = await this.getUserAddressesUseCase.execute(userId);
    
    return addresses.map((address) => ({
      id: address.id,
      userId: address.userId,
      label: address.label,
      addressLine1: address.addressLine1,
      addressLine2: address.addressLine2,
      city: address.city,
      stateProvince: address.stateProvince,
      postalCode: address.postalCode,
      country: address.country,
      phone: address.phone,
      isDefault: address.isDefault,
      isActive: address.isActive,
      createdAt: address.createdAt,
      updatedAt: address.updatedAt,
    }));
  }

  @Put(':id')
  @ApiOperation({ summary: 'Actualizar una dirección existente' })
  @ApiParam({ name: 'id', description: 'ID de la dirección' })
  @ApiResponse({ status: 200, description: 'Dirección actualizada', type: UserAddressResponseDto })
  @ApiResponse({ status: 404, description: 'Dirección no encontrada' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async update(
    @Param('id') id: string,
    @Body() dto: UpdateUserAddressRequestDto,
  ): Promise<UserAddressResponseDto> {
    const address = await this.updateUserAddressUseCase.execute(parseInt(id), dto);
    
    return {
      id: address.id,
      userId: address.userId,
      label: address.label,
      addressLine1: address.addressLine1,
      addressLine2: address.addressLine2,
      city: address.city,
      stateProvince: address.stateProvince,
      postalCode: address.postalCode,
      country: address.country,
      phone: address.phone,
      isDefault: address.isDefault,
      isActive: address.isActive,
      createdAt: address.createdAt,
      updatedAt: address.updatedAt,
    };
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Eliminar una dirección (soft delete)' })
  @ApiParam({ name: 'id', description: 'ID de la dirección' })
  @ApiResponse({ status: 204, description: 'Dirección eliminada' })
  @ApiResponse({ status: 404, description: 'Dirección no encontrada' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async delete(@Param('id') id: string): Promise<void> {
    await this.deleteUserAddressUseCase.execute(parseInt(id));
  }

  @Patch(':id/set-default')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Establecer una dirección como predeterminada' })
  @ApiParam({ name: 'id', description: 'ID de la dirección' })
  @ApiResponse({ status: 204, description: 'Dirección marcada como predeterminada' })
  @ApiResponse({ status: 404, description: 'Dirección no encontrada' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async setAsDefault(
    @Request() req,
    @Param('id') id: string,
  ): Promise<void> {
    const userId = parseInt(req.user.sub);
    await this.setDefaultAddressUseCase.execute(userId, parseInt(id));
  }
}
