import { ApiProperty } from '@nestjs/swagger';

export class BillingRecordResponseDto {
  @ApiProperty({ description: 'Invoice ID' })
  id: number;

  @ApiProperty({ description: 'Invoice UUID' })
  uuid: string;

  @ApiProperty({ description: 'Invoice number' })
  number: string;

  @ApiProperty({ description: 'User ID' })
  userId: number;

  @ApiProperty({ description: 'Customer name' })
  customerName: string;

  @ApiProperty({ description: 'Customer email' })
  customerEmail: string;

  @ApiProperty({ description: 'Order ID' })
  orderId: number;

  @ApiProperty({ description: 'Order UUID' })
  orderUuid: string;

  @ApiProperty({ description: 'Invoice status' })
  status: string;

  @ApiProperty({ description: 'Total amount' })
  total: number;

  @ApiProperty({ description: 'Issued date' })
  issuedAt: Date | null;

  @ApiProperty({ description: 'Created date' })
  createdAt: Date;
}
