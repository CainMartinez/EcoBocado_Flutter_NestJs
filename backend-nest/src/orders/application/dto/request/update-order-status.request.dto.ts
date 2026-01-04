import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsString } from 'class-validator';

const ORDER_STATUSES = ['draft', 'pending_payment', 'confirmed', 'prepared', 'delivered', 'cancelled', 'completed'] as const;

export class UpdateOrderStatusRequestDto {
  @ApiProperty({
    description: 'Nuevo estado del pedido',
    enum: ORDER_STATUSES,
    example: 'delivered',
  })
  @IsString()
  @IsEnum(ORDER_STATUSES)
  status: typeof ORDER_STATUSES[number];
}
