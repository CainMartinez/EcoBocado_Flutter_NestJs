import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class PaymentIntentResponseDto {
  @ApiProperty({
    description: 'Client secret de Stripe para completar el pago',
    example: 'pi_3ABC123_secret_xyz789',
  })
  clientSecret: string;

  @ApiProperty({
    description: 'ID del Payment Intent de Stripe',
    example: 'pi_3ABC123DEF456',
  })
  paymentIntentId: string;

  @ApiProperty({
    description: 'Monto en centavos',
    example: 2999,
  })
  amount: number;

  @ApiProperty({
    description: 'Moneda',
    example: 'eur',
  })
  currency: string;

  @ApiProperty({
    description: 'Estado del pago',
    enum: ['pending', 'succeeded', 'failed', 'canceled'],
    example: 'pending',
  })
  status: string;

  @ApiPropertyOptional({
    description: 'ID de la orden asociada',
    example: 5,
    nullable: true,
  })
  orderId?: number | null;
}

export class PaymentResponseDto {
  @ApiProperty({ description: 'ID del registro de pago', example: 1 })
  id: number;

  @ApiProperty({
    description: 'ID del Payment Intent de Stripe',
    example: 'pi_3ABC123DEF456',
  })
  stripePaymentIntentId: string;

  @ApiPropertyOptional({
    description: 'ID de la orden asociada',
    example: 5,
    nullable: true,
  })
  orderId: number | null;

  @ApiProperty({ description: 'ID del usuario', example: 10 })
  userId: number;

  @ApiProperty({ description: 'Monto en centavos', example: 2999 })
  amount: number;

  @ApiProperty({ description: 'Moneda', example: 'EUR' })
  currency: string;

  @ApiProperty({
    description: 'Estado del pago',
    enum: ['pending', 'succeeded', 'failed', 'canceled'],
    example: 'succeeded',
  })
  status: string;

  @ApiPropertyOptional({
    description: 'Método de pago utilizado',
    example: 'card',
    nullable: true,
  })
  paymentMethod: string | null;

  @ApiPropertyOptional({
    description: 'URL del recibo',
    example: 'https://stripe.com/receipt/...',
    nullable: true,
  })
  receiptUrl: string | null;

  @ApiProperty({ description: 'Fecha de creación' })
  createdAt: Date;

  @ApiProperty({ description: 'Fecha de actualización' })
  updatedAt: Date;
}
