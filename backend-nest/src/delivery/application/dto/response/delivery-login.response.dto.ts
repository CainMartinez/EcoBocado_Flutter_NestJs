import { ApiProperty } from '@nestjs/swagger';

class DeliveryDriverDto {
  @ApiProperty({ example: 1, description: 'ID del repartidor' })
  id: number;

  @ApiProperty({ example: '123e4567-e89b-12d3-a456-426614174000', description: 'UUID único del repartidor' })
  uuid: string | null;

  @ApiProperty({ example: 'driver@example.com', description: 'Email del repartidor' })
  email: string;

  @ApiProperty({ example: 'Juan Repartidor', description: 'Nombre del repartidor' })
  name: string;

  @ApiProperty({ example: '+34666777888', description: 'Teléfono del repartidor' })
  phone: string;

  @ApiProperty({ example: null, description: 'URL del avatar', required: false })
  avatarUrl: string | null;

  @ApiProperty({ example: true, description: 'Indica si el repartidor está disponible para entregas' })
  isAvailable: boolean;

  @ApiProperty({ example: 'motorcycle', description: 'Tipo de vehículo', required: false })
  vehicleType: string | null;

  @ApiProperty({ example: 'ABC1234', description: 'Matrícula del vehículo', required: false })
  vehiclePlate: string | null;
}

/**
 * Respuesta del endpoint de login de repartidores
 * Incluye el token JWT de acceso con duración de 8 horas (sin refresh token)
 */
export class DeliveryLoginResponseDto {
  @ApiProperty({
    example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
    description: 'Token JWT de acceso válido por 8 horas',
  })
  accessToken: string;

  @ApiProperty({
    example: 1671234567,
    description: 'Timestamp de expiración del token',
  })
  expiresIn: number;

  @ApiProperty({
    description: 'Datos públicos del repartidor',
    type: DeliveryDriverDto,
  })
  driver: DeliveryDriverDto;
}
