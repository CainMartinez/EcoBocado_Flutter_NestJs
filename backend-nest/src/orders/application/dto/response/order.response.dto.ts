import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { OrderItemResponseDto } from './order-item.response.dto';

export class OrderResponseDto {
  @ApiProperty({ description: 'ID del pedido', example: 1 })
  id: number;

  @ApiPropertyOptional({ 
    description: 'UUID único del pedido',
    example: '550e8400-e29b-41d4-a716-446655440000',
    nullable: true,
  })
  uuid: string | null;

  @ApiProperty({ description: 'ID del usuario que realizó el pedido', example: 5 })
  userId: number;

  @ApiProperty({ 
    description: 'Estado del pedido',
    enum: ['draft', 'confirmed', 'prepared', 'delivered', 'cancelled'],
    example: 'confirmed',
  })
  status: string;

  @ApiProperty({ 
    description: 'Tipo de entrega',
    enum: ['pickup', 'delivery'],
    example: 'delivery',
  })
  deliveryType: 'pickup' | 'delivery';

  @ApiPropertyOptional({ 
    description: 'ID del slot de recogida',
    example: 3,
    nullable: true,
  })
  pickupSlotId: number | null;

  @ApiPropertyOptional({ 
    description: 'ID del Payment Intent de Stripe',
    example: 'pi_3ABC123DEF456',
    nullable: true,
  })
  paymentIntentId: string | null;

  @ApiProperty({ description: 'Subtotal del pedido', example: 29.97 })
  subtotal: number;

  @ApiProperty({ description: 'Total del pedido', example: 29.97 })
  total: number;

  @ApiProperty({ description: 'Moneda', example: 'EUR' })
  currency: string;

  @ApiPropertyOptional({ 
    description: 'Notas del pedido',
    example: 'Sin cebolla',
    nullable: true,
  })
  notes: string | null;

  @ApiProperty({ 
    description: 'Items del pedido',
    type: [OrderItemResponseDto],
  })
  items: OrderItemResponseDto[];

  @ApiPropertyOptional({
    description: 'Información de entrega (solo si deliveryType es "delivery")',
    nullable: true,
  })
  delivery?: {
    addressLine1: string;
    addressLine2: string | null;
    city: string;
    postalCode: string;
    phone: string | null;
  } | null;

  @ApiProperty({ description: 'Fecha de creación del pedido' })
  createdAt: Date;

  @ApiProperty({ description: 'Fecha de última actualización' })
  updatedAt: Date;
}
