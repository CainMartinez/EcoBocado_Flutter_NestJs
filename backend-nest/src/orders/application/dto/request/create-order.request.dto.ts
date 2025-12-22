import { IsArray, IsEnum, IsInt, IsNotEmpty, IsNumber, IsOptional, IsString, Min, ValidateNested, ValidateIf } from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateOrderItemDto {
  @ApiProperty({
    description: 'Tipo de item: producto o menú',
    enum: ['product', 'menu'],
    example: 'product',
  })
  @IsNotEmpty()
  @IsString()
  itemType: 'product' | 'menu';

  @ApiProperty({
    description: 'ID del producto o menú según el tipo',
    example: 1,
    type: 'integer',
  })
  @IsNotEmpty()
  @IsInt()
  itemId: number;

  @ApiProperty({
    description: 'Cantidad del item',
    example: 2,
    minimum: 1,
  })
  @IsNotEmpty()
  @IsNumber()
  @Min(1)
  quantity: number;

  @ApiProperty({
    description: 'Precio unitario del item',
    example: 9.99,
    minimum: 0,
  })
  @IsNotEmpty()
  @IsNumber()
  @Min(0)
  unitPrice: number;
}

export class CreateOrderRequestDto {
  @ApiProperty({
    description: 'Lista de items del pedido',
    type: [CreateOrderItemDto],
  })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreateOrderItemDto)
  items: CreateOrderItemDto[];

  @ApiProperty({
    description: 'Tipo de entrega: recogida en tienda o envío a domicilio',
    enum: ['pickup', 'delivery'],
    example: 'pickup',
  })
  @IsNotEmpty()
  @IsEnum(['pickup', 'delivery'])
  deliveryType: 'pickup' | 'delivery';

  @ApiPropertyOptional({
    description: 'ID del slot de recogida (obligatorio si deliveryType=pickup)',
    example: 5,
    type: 'integer',
  })
  @ValidateIf(o => o.deliveryType === 'pickup')
  @IsNotEmpty()
  @IsInt()
  pickupSlotId?: number;

  @ApiPropertyOptional({
    description: 'Fecha de recogida en formato YYYY-MM-DD (obligatorio si deliveryType=pickup y pickupSlotId no existe)',
    example: '2025-12-21',
  })
  @ValidateIf(o => o.deliveryType === 'pickup')
  @IsOptional()
  @IsString()
  pickupDate?: string;

  @ApiPropertyOptional({
    description: 'Hora de inicio del slot en formato HH:MM:SS',
    example: '12:00:00',
  })
  @ValidateIf(o => o.deliveryType === 'pickup')
  @IsOptional()
  @IsString()
  pickupStartTime?: string;

  @ApiPropertyOptional({
    description: 'Hora de fin del slot en formato HH:MM:SS',
    example: '12:30:00',
  })
  @ValidateIf(o => o.deliveryType === 'pickup')
  @IsOptional()
  @IsString()
  pickupEndTime?: string;

  @ApiPropertyOptional({
    description: 'ID del local/tienda para recogida',
    example: 1,
    type: 'integer',
  })
  @ValidateIf(o => o.deliveryType === 'pickup')
  @IsOptional()
  @IsInt()
  venueId?: number;

  @ApiPropertyOptional({
    description: 'ID de dirección guardada del usuario (opcional si deliveryType=delivery)',
    example: 1,
    type: 'integer',
  })
  @ValidateIf(o => o.deliveryType === 'delivery')
  @IsOptional()
  @IsInt()
  userAddressId?: number;

  @ApiPropertyOptional({
    description: 'Dirección línea 1 (obligatorio si deliveryType=delivery y no se usa userAddressId)',
    example: 'Calle Mayor 123, 2ºB',
  })
  @ValidateIf(o => o.deliveryType === 'delivery' && !o.userAddressId)
  @IsNotEmpty()
  @IsString()
  addressLine1?: string;

  @ApiPropertyOptional({
    description: 'Dirección línea 2 (opcional)',
    example: 'Edificio A',
  })
  @IsOptional()
  @IsString()
  addressLine2?: string;

  @ApiPropertyOptional({
    description: 'Ciudad (obligatorio si deliveryType=delivery y no se usa userAddressId)',
    example: 'Madrid',
  })
  @ValidateIf(o => o.deliveryType === 'delivery' && !o.userAddressId)
  @IsNotEmpty()
  @IsString()
  city?: string;

  @ApiPropertyOptional({
    description: 'Provincia/Estado (opcional)',
    example: 'Madrid',
  })
  @IsOptional()
  @IsString()
  stateProvince?: string;

  @ApiPropertyOptional({
    description: 'Código postal (obligatorio si deliveryType=delivery y no se usa userAddressId)',
    example: '28001',
  })
  @ValidateIf(o => o.deliveryType === 'delivery' && !o.userAddressId)
  @IsNotEmpty()
  @IsString()
  postalCode?: string;

  @ApiPropertyOptional({
    description: 'País (código ISO de 2 letras)',
    example: 'ES',
    default: 'ES',
  })
  @IsOptional()
  @IsString()
  country?: string;

  @ApiPropertyOptional({
    description: 'Teléfono de contacto para la entrega',
    example: '+34 600 123 456',
  })
  @IsOptional()
  @IsString()
  deliveryPhone?: string;

  @ApiPropertyOptional({
    description: 'Notas de entrega (instrucciones especiales)',
    example: 'Llamar al timbre 2B',
  })
  @IsOptional()
  @IsString()
  deliveryNotes?: string;

  @ApiPropertyOptional({
    description: 'Fecha estimada de entrega (YYYY-MM-DD)',
    example: '2025-12-21',
  })
  @ValidateIf(o => o.deliveryType === 'delivery')
  @IsOptional()
  @IsString()
  estimatedDeliveryDate?: string;

  @ApiPropertyOptional({
    description: 'Hora estimada de entrega (HH:MM:SS)',
    example: '14:00:00',
  })
  @ValidateIf(o => o.deliveryType === 'delivery')
  @IsOptional()
  @IsString()
  estimatedDeliveryTime?: string;

  @ApiPropertyOptional({
    description: 'Notas adicionales para el pedido (alergias, preferencias, etc.)',
    example: 'Sin cebolla, por favor',
  })
  @IsOptional()
  @IsString()
  notes?: string;

  @ApiPropertyOptional({
    description: 'ID del Payment Intent de Stripe (obligatorio para confirmar pedido)',
    example: 'pi_3ABC123DEF456',
  })
  @IsOptional()
  @IsString()
  paymentIntentId?: string;
}
