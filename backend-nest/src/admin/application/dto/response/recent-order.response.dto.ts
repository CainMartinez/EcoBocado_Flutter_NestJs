import { ApiProperty } from '@nestjs/swagger';

export class RecentOrderResponseDto {
  @ApiProperty({ description: 'Order ID' })
  id: number;

  @ApiProperty({ description: 'Order UUID' })
  uuid: string;

  @ApiProperty({ description: 'Customer name' })
  customerName: string;

  @ApiProperty({ description: 'Order type (pickup/delivery)' })
  orderType: string;

  @ApiProperty({ description: 'Order status' })
  status: string;

  @ApiProperty({ description: 'Total amount' })
  totalAmount: number;

  @ApiProperty({ description: 'Order created date' })
  createdAt: Date;
}
