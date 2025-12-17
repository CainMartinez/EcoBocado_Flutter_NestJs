import { ApiProperty } from '@nestjs/swagger';

/**
 * Respuesta del endpoint de registro de repartidores
 * Retorna los datos del repartidor recién creado
 */
export class DeliveryRegisterResponseDto {
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

  @ApiProperty({ example: false, description: 'Disponibilidad inicial (por defecto false)' })
  isAvailable: boolean;

  @ApiProperty({ example: 'motorcycle', description: 'Tipo de vehículo', required: false })
  vehicleType: string | null;

  @ApiProperty({ example: 'ABC1234', description: 'Matrícula del vehículo', required: false })
  vehiclePlate: string | null;

  @ApiProperty({ example: '2025-12-17T10:30:00.000Z', description: 'Fecha de creación' })
  createdAt: Date;
}
