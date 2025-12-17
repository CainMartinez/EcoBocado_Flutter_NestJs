import { Controller, Get, Patch, Body, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiOkResponse, ApiUnauthorizedResponse, ApiBearerAuth, ApiProperty, ApiBadRequestResponse } from '@nestjs/swagger';
import { IsBoolean } from 'class-validator';
import { DeliveryJwtAuthGuard } from '../guards/delivery-jwt-auth.guard';
import { GetDeliveryProfileUseCase } from '../../application/use_cases/get-delivery-profile.usecase';
import { UpdateAvailabilityUseCase } from '../../application/use_cases/update-availability.usecase';
import { DeliveryDriverPublicAssembler } from '../assemblers/delivery-driver-public.assembler';

/**
 * DTO para actualizar la disponibilidad del repartidor
 */
class UpdateAvailabilityDto {
  @ApiProperty({
    example: true,
    description: 'Nueva disponibilidad del repartidor para recibir pedidos',
  })
  @IsBoolean({ message: 'isAvailable debe ser un booleano' })
  isAvailable: boolean;
}

/**
 * DTO de respuesta con los datos públicos del repartidor
 */
class DeliveryDriverPublicDto {
  @ApiProperty({ example: 1, description: 'ID del repartidor' })
  id: number;

  @ApiProperty({ example: '123e4567-e89b-12d3-a456-426614174000', description: 'UUID único' })
  uuid: string | null;

  @ApiProperty({ example: 'driver@example.com', description: 'Email' })
  email: string;

  @ApiProperty({ example: 'Juan Repartidor', description: 'Nombre' })
  name: string;

  @ApiProperty({ example: '+34666777888', description: 'Teléfono' })
  phone: string;

  @ApiProperty({ example: null, description: 'URL del avatar', required: false })
  avatarUrl: string | null;

  @ApiProperty({ example: true, description: 'Disponibilidad para entregas' })
  isAvailable: boolean;

  @ApiProperty({ example: 'motorcycle', description: 'Tipo de vehículo', required: false })
  vehicleType: string | null;

  @ApiProperty({ example: 'ABC1234', description: 'Matrícula', required: false })
  vehiclePlate: string | null;
}

/**
 * Controlador de perfil del repartidor
 * Gestiona la información personal y disponibilidad del repartidor autenticado
 */
@ApiTags('Delivery - Perfil')
@Controller('delivery/profile')
@UseGuards(DeliveryJwtAuthGuard)
@ApiBearerAuth()
export class DeliveryProfileController {
  constructor(
    private readonly getProfileUseCase: GetDeliveryProfileUseCase,
    private readonly updateAvailabilityUseCase: UpdateAvailabilityUseCase,
    private readonly assembler: DeliveryDriverPublicAssembler,
  ) {}

  /**
   * Obtener perfil del repartidor autenticado
   * 
   * Retorna la información completa del repartidor que ha iniciado sesión
   */
  @Get('me')
  @ApiOperation({
    summary: 'Obtener perfil del repartidor',
    description: 'Retorna los datos del repartidor autenticado mediante el token JWT',
  })
  @ApiOkResponse({
    description: 'Perfil del repartidor obtenido exitosamente',
    type: DeliveryDriverPublicDto,
  })
  @ApiUnauthorizedResponse({
    description: 'Token inválido, expirado o repartidor inactivo',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
      },
    },
  })
  async getProfile(@Request() req: any): Promise<DeliveryDriverPublicDto> {
    const driver = await this.getProfileUseCase.execute(req.user.driverId);
    return this.assembler.toPublic(driver);
  }

  /**
   * Actualizar disponibilidad del repartidor
   * 
   * Permite al repartidor marcar si está disponible o no para recibir pedidos.
   * Cuando está disponible (true), puede recibir notificaciones de nuevos pedidos.
   */
  @Patch('availability')
  @ApiOperation({
    summary: 'Actualizar disponibilidad',
    description: 'Cambia el estado de disponibilidad del repartidor para recibir pedidos',
  })
  @ApiOkResponse({
    description: 'Disponibilidad actualizada exitosamente',
    type: DeliveryDriverPublicDto,
  })
  @ApiUnauthorizedResponse({
    description: 'Token inválido o expirado',
  })
  @ApiBadRequestResponse({
    description: 'El campo isAvailable debe ser un booleano',
    schema: {
      example: {
        statusCode: 400,
        message: ['isAvailable debe ser un booleano'],
        error: 'Bad Request',
      },
    },
  })
  async updateAvailability(
    @Request() req: any,
    @Body() body: UpdateAvailabilityDto,
  ): Promise<DeliveryDriverPublicDto> {
    const driver = await this.updateAvailabilityUseCase.execute(
      req.user.driverId,
      body.isAvailable,
    );
    return this.assembler.toPublic(driver);
  }
}
