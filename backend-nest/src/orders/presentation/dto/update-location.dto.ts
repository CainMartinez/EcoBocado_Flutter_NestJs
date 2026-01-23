import { ApiProperty } from '@nestjs/swagger';
import { IsNumber, IsOptional, Min, Max } from 'class-validator';

export class UpdateLocationDto {
  @ApiProperty({
    description: 'Latitud GPS del repartidor (rango válido: -90 a 90)',
    example: 40.416775,
    minimum: -90,
    maximum: 90,
    type: Number,
  })
  @IsNumber()
  @Min(-90)
  @Max(90)
  latitude: number;

  @ApiProperty({
    description: 'Longitud GPS del repartidor (rango válido: -180 a 180)',
    example: -3.703790,
    minimum: -180,
    maximum: 180,
    type: Number,
  })
  @IsNumber()
  @Min(-180)
  @Max(180)
  longitude: number;

  @ApiProperty({
    description: '[DEPRECATED - No usar] La ubicación se asocia automáticamente al repartidor, no a un pedido específico. Esto permite que múltiples clientes vean la misma ubicación del repartidor.',
    example: null,
    required: false,
    type: Number,
    deprecated: true,
  })
  @IsOptional()
  @IsNumber()
  orderId?: number;
}
