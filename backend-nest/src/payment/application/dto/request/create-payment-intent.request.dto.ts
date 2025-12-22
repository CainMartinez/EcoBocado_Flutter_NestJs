import { IsInt, IsNotEmpty, IsNumber, IsOptional, IsString, Min } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreatePaymentIntentRequestDto {
  @ApiProperty({
    description: 'Monto en centavos (ej: 1000 = 10.00 EUR)',
    example: 2999,
    minimum: 50,
  })
  @IsNotEmpty()
  @IsInt()
  @Min(50)
  amount: number;

  @ApiProperty({
    description: 'Código de moneda ISO',
    example: 'eur',
    default: 'eur',
  })
  @IsNotEmpty()
  @IsString()
  currency: string;

  @ApiPropertyOptional({
    description: 'ID de la orden asociada (opcional)',
    example: 5,
  })
  @IsOptional()
  @IsInt()
  orderId?: number;

  @ApiPropertyOptional({
    description: 'Metadatos adicionales para Stripe',
    example: { orderId: '123', userId: '456' },
  })
  @IsOptional()
  metadata?: Record<string, string>;
}
