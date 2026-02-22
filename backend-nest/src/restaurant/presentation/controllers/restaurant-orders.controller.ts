import { Controller, Get, Patch, Param, Body, UseGuards, ParseIntPipe, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiBearerAuth, ApiOperation, ApiResponse, ApiParam } from '@nestjs/swagger';
import { RestaurantJwtAuthGuard } from '../guards/restaurant-jwt-auth.guard';
import { GetRestaurantOrdersUseCase } from '../../application/use_cases/get-restaurant-orders.usecase';
import { GetRestaurantStatsUseCase } from '../../application/use_cases/get-restaurant-stats.usecase';
import { UpdateRestaurantOrderStatusUseCase } from '../../application/use_cases/update-restaurant-order-status.usecase';

class UpdateStatusDto {
  status: string;
}

/**
 * Controlador de pedidos del restaurante
 * Gestiona pedidos de tipo pickup asignados al restaurante
 */
@ApiTags('Restaurant - Pedidos')
@ApiBearerAuth()
@Controller('restaurant/orders')
@UseGuards(RestaurantJwtAuthGuard)
export class RestaurantOrdersController {
  constructor(
    private readonly getOrdersUseCase: GetRestaurantOrdersUseCase,
    private readonly getStatsUseCase: GetRestaurantStatsUseCase,
    private readonly updateStatusUseCase: UpdateRestaurantOrderStatusUseCase,
  ) {}

  @Get()
  @ApiOperation({
    summary: 'Obtener pedidos pickup del restaurante',
    description: 'Lista todos los pedidos de tipo pickup en estados activos',
  })
  @ApiResponse({ status: 200, description: 'Lista de pedidos recuperada' })
  async getOrders() {
    return await this.getOrdersUseCase.execute();
  }

  @Get('stats')
  @ApiOperation({
    summary: 'Obtener estadísticas del restaurante',
    description: 'Estadísticas de pedidos pickup: pendientes, preparados, completados, ingresos',
  })
  @ApiResponse({ status: 200, description: 'Estadísticas recuperadas' })
  async getStats() {
    return await this.getStatsUseCase.execute();
  }

  @Patch(':id/status')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Actualizar estado de un pedido pickup',
    description: 'Transiciones permitidas: confirmed→prepared, prepared→completed',
  })
  @ApiParam({ name: 'id', description: 'ID del pedido', type: 'integer' })
  @ApiResponse({ status: 200, description: 'Estado actualizado' })
  @ApiResponse({ status: 400, description: 'Transición no permitida' })
  @ApiResponse({ status: 404, description: 'Pedido no encontrado' })
  async updateStatus(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateStatusDto,
  ): Promise<{ message: string }> {
    await this.updateStatusUseCase.execute(id, dto.status);
    return { message: 'Estado actualizado correctamente' };
  }
}
