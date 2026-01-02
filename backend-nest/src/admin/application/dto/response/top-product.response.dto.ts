import { ApiProperty } from '@nestjs/swagger';

export class TopProductResponseDto {
  @ApiProperty({ description: 'Product ID' })
  id: number;

  @ApiProperty({ description: 'Product name (Spanish)' })
  nameEs: string;

  @ApiProperty({ description: 'Product name (English)' })
  nameEn: string;

  @ApiProperty({ description: 'Total quantity sold' })
  totalSold: number;

  @ApiProperty({ description: 'Total revenue from this product' })
  revenue: number;
}
