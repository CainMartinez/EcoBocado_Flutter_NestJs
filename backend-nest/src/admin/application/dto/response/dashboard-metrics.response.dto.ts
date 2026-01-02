import { ApiProperty } from '@nestjs/swagger';

export class DashboardMetricsResponseDto {
  @ApiProperty({ description: 'Total number of orders' })
  totalOrders: number;

  @ApiProperty({ description: 'Total revenue in EUR' })
  totalRevenue: number;

  @ApiProperty({ description: 'Total number of products' })
  totalProducts: number;

  @ApiProperty({ description: 'Total number of users' })
  totalUsers: number;
}
