import { Body, Controller, Post, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiOkResponse, ApiUnauthorizedResponse, ApiBadRequestResponse } from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { DeliveryLoginUseCase } from '../../application/use_cases/delivery-login.usecase';
import { DeliveryLoginRequestDto } from '../../application/dto/request/delivery-login.request.dto';
import { DeliveryLoginResponseDto } from '../../application/dto/response/delivery-login.response.dto';
import { DeliveryDriverPublicAssembler } from '../assemblers/delivery-driver-public.assembler';

/**
 * Controlador de autenticación para repartidores
 * Gestiona el login de repartidores con token JWT de 8 horas (sin refresh token)
 */
@ApiTags('Delivery - Autenticación')
@Controller('delivery/auth')
export class DeliveryLoginController {
  constructor(
    private readonly loginUseCase: DeliveryLoginUseCase,
    private readonly assembler: DeliveryDriverPublicAssembler,
  ) {}

  /**
   * Login de repartidor
   * 
   * Autentica a un repartidor y retorna un token JWT válido por 8 horas.
   * No incluye refresh token por diseño de seguridad.
   * 
   * Protegido con rate limiter: 5 intentos por minuto por IP
   */
  @Post('login')
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { ttl: 60, limit: 5 } })
  @ApiOperation({
    summary: 'Login de repartidor',
    description: 'Autentica a un repartidor y genera un token JWT con duración de 8 horas. No incluye refresh token.',
  })
  @ApiOkResponse({
    description: 'Login exitoso. Retorna token JWT y datos del repartidor',
    type: DeliveryLoginResponseDto,
  })
  @ApiUnauthorizedResponse({
    description: 'Credenciales inválidas o repartidor inactivo',
    schema: {
      example: {
        statusCode: 401,
        message: 'Invalid password',
        error: 'Unauthorized',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Datos de entrada inválidos',
    schema: {
      example: {
        statusCode: 400,
        message: ['Email inválido', 'La contraseña debe tener al menos 6 caracteres'],
        error: 'Bad Request',
      },
    },
  })
  async login(@Body() dto: DeliveryLoginRequestDto): Promise<DeliveryLoginResponseDto> {
    const result = await this.loginUseCase.execute(dto);

    return {
      accessToken: result.accessToken,
      expiresIn: result.expiresIn,
      driver: this.assembler.toPublic(result.driver),
    };
  }
}
