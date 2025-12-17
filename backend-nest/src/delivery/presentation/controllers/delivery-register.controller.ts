import { Body, Controller, Post, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiCreatedResponse, ApiConflictResponse, ApiBadRequestResponse, ApiBearerAuth } from '@nestjs/swagger';
import { RegisterDeliveryDriverUseCase } from '../../application/use_cases/register-delivery-driver.usecase';
import { DeliveryRegisterRequestDto } from '../../application/dto/request/delivery-register.request.dto';
import { DeliveryRegisterResponseDto } from '../../application/dto/response/delivery-register.response.dto';
import { DeliveryDriverPublicAssembler } from '../assemblers/delivery-driver-public.assembler';

/**
 * Controlador de registro de repartidores
 * 
 * ⚠️ IMPORTANTE: Este endpoint debe estar protegido con un guard de administrador
 * en producción. NO debe ser accesible desde la aplicación móvil de repartidores.
 */
@ApiTags('Delivery - Autenticación')
@Controller('delivery/auth')
export class DeliveryRegisterController {
  constructor(
    private readonly registerUseCase: RegisterDeliveryDriverUseCase,
    private readonly assembler: DeliveryDriverPublicAssembler,
  ) {}

  /**
   * Registro de nuevo repartidor
   * 
   * Crea un nuevo repartidor en el sistema. El repartidor se crea con:
   * - Estado activo (isActive: true)
   * - No disponible para entregas (isAvailable: false)
   * - UUID generado automáticamente
   * - Contraseña hasheada
   * 
   * ⚠️ Este endpoint debe ser protegido y solo accesible desde el panel de administración
   */
  @Post('register')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Registrar nuevo repartidor',
    description: 'Crea un nuevo repartidor en el sistema. Solo debe ser accesible desde el panel de administración.',
  })
  @ApiCreatedResponse({
    description: 'Repartidor registrado exitosamente',
    type: DeliveryRegisterResponseDto,
  })
  @ApiConflictResponse({
    description: 'El email ya está registrado',
    schema: {
      example: {
        statusCode: 409,
        message: 'Delivery driver with email driver@example.com already exists',
        error: 'Conflict',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Datos de entrada inválidos',
    schema: {
      example: {
        statusCode: 400,
        message: [
          'Email inválido',
          'El nombre debe tener al menos 2 caracteres',
          'El teléfono debe tener al menos 9 caracteres',
          'La contraseña debe tener al menos 6 caracteres',
        ],
        error: 'Bad Request',
      },
    },
  })
  async register(@Body() dto: DeliveryRegisterRequestDto): Promise<DeliveryRegisterResponseDto> {
    const driver = await this.registerUseCase.execute(dto);

    return {
      ...this.assembler.toPublic(driver),
      createdAt: driver.createdAt,
    };
  }
}
