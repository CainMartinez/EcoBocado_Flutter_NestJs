import { ApiProperty } from '@nestjs/swagger';

class VenueDto {
  @ApiProperty({ example: 1, description: 'ID del restaurante' })
  id: number;

  @ApiProperty({ example: '123e4567-e89b-12d3-a456-426614174000', description: 'UUID único' })
  uuid: string | null;

  @ApiProperty({ example: 'PUB_DIFERENT_ALBAIDA', description: 'Código del restaurante' })
  code: string | null;

  @ApiProperty({ example: 'restaurante@ecobocado.com', description: 'Email', required: false })
  email: string | null;

  @ApiProperty({ example: 'Pub Diferent Albaida', description: 'Nombre', required: false })
  name: string | null;

  @ApiProperty({ example: '+34666777888', description: 'Teléfono', required: false })
  phone: string | null;

  @ApiProperty({ example: null, description: 'URL del avatar', required: false })
  avatarUrl: string | null;

  @ApiProperty({ example: 'Europe/Madrid', description: 'Zona horaria' })
  timezone: string;
}

export class RestaurantLoginResponseDto {
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
    description: 'Datos públicos del restaurante',
    type: VenueDto,
  })
  venue: VenueDto;
}
