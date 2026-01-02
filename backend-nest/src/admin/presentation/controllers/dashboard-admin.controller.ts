import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../../auth/presentation/guards/jwt-auth.guard';
import { AdminGuard } from '../../../auth/presentation/guards/admin.guard';
import { GetDashboardMetricsUseCase } from '../../application/use_cases/get-dashboard-metrics.usecase';
import { GetRecentOrdersUseCase } from '../../application/use_cases/get-recent-orders.usecase';
import { GetTopProductsUseCase } from '../../application/use_cases/get-top-products.usecase';
import { DashboardMetricsResponseDto } from '../../application/dto/response/dashboard-metrics.response.dto';
import { RecentOrderResponseDto } from '../../application/dto/response/recent-order.response.dto';
import { TopProductResponseDto } from '../../application/dto/response/top-product.response.dto';

@ApiTags('Admin - Dashboard')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, AdminGuard)
@Controller('admin/dashboard')
export class DashboardAdminController {
  constructor(
    private readonly getDashboardMetricsUseCase: GetDashboardMetricsUseCase,
    private readonly getRecentOrdersUseCase: GetRecentOrdersUseCase,
    private readonly getTopProductsUseCase: GetTopProductsUseCase,
  ) {}

  @Get('metrics')
  @ApiOperation({ summary: 'Get dashboard metrics (admin only)' })
  @ApiResponse({
    status: 200,
    description: 'Dashboard metrics retrieved successfully',
    type: DashboardMetricsResponseDto,
  })
  async getMetrics(): Promise<DashboardMetricsResponseDto> {
    return this.getDashboardMetricsUseCase.execute();
  }

  @Get('recent-orders')
  @ApiOperation({ summary: 'Get recent orders (admin only)' })
  @ApiResponse({
    status: 200,
    description: 'Recent orders retrieved successfully',
    type: [RecentOrderResponseDto],
  })
  async getRecentOrders(
    @Query('limit') limit?: number,
  ): Promise<RecentOrderResponseDto[]> {
    return this.getRecentOrdersUseCase.execute(limit || 10);
  }

  @Get('top-products')
  @ApiOperation({ summary: 'Get top selling products (admin only)' })
  @ApiResponse({
    status: 200,
    description: 'Top products retrieved successfully',
    type: [TopProductResponseDto],
  })
  async getTopProducts(
    @Query('limit') limit?: number,
  ): Promise<TopProductResponseDto[]> {
    return this.getTopProductsUseCase.execute(limit || 10);
  }
}
