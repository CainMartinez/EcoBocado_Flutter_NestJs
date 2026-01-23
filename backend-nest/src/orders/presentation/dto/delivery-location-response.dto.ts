import { ApiProperty } from '@nestjs/swagger';

export class DeliveryLocationResponseDto {
  @ApiProperty({
    description: 'ID del repartidor',
    example: 5,
    type: Number,
  })
  deliveryUserId: number;

  @ApiProperty({
    description: 'ID del pedido asociado (null si no hay pedido activo)',
    example: 123,
    nullable: true,
    type: Number,
  })
  orderId: number | null;

  @ApiProperty({
    description: 'Latitud GPS (precisión de 8 decimales ≈ 1.1mm)',
    example: 40.416775,
    type: Number,
  })
  latitude: number;

  @ApiProperty({
    description: 'Longitud GPS (precisión de 8 decimales ≈ 1.1mm)',
    example: -3.703790,
    type: Number,
  })
  longitude: number;

  @ApiProperty({
    description: 'Fecha y hora de la última actualización',
    example: '2026-01-23T20:15:30.000Z',
    type: Date,
  })
  updatedAt: Date;
}
