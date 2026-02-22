import { Body, Controller, Post, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiOkResponse, ApiUnauthorizedResponse, ApiBadRequestResponse } from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { RestaurantLoginUseCase } from '../../application/use_cases/restaurant-login.usecase';
import { RestaurantLoginRequestDto } from '../../application/dto/request/restaurant-login.request.dto';
import { RestaurantLoginResponseDto } from '../../application/dto/response/restaurant-login.response.dto';
import { VenuePublicAssembler } from '../assemblers/venue-public.assembler';

/**
 * Controlador de autenticación para restaurantes
 * Gestiona el login de empleados del restaurante con token JWT de 8 horas
 */
@ApiTags('Restaurant - Autenticación')
@Controller('restaurant/auth')
export class RestaurantLoginController {
  constructor(
    private readonly loginUseCase: RestaurantLoginUseCase,
    private readonly assembler: VenuePublicAssembler,
  ) {}

  @Post('login')
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { ttl: 60, limit: 5 } })
  @ApiOperation({
    summary: 'Login de restaurante',
    description: 'Autentica a un restaurante y genera un token JWT con duración de 8 horas.',
  })
  @ApiOkResponse({
    description: 'Login exitoso. Retorna token JWT y datos del restaurante',
    type: RestaurantLoginResponseDto,
  })
  @ApiUnauthorizedResponse({ description: 'Credenciales inválidas o restaurante inactivo' })
  @ApiBadRequestResponse({ description: 'Datos de entrada inválidos' })
  async login(@Body() dto: RestaurantLoginRequestDto): Promise<RestaurantLoginResponseDto> {
    const result = await this.loginUseCase.execute(dto);

    return {
      accessToken: result.accessToken,
      expiresIn: result.expiresIn,
      venue: this.assembler.toPublic(result.venue),
    };
  }
}
