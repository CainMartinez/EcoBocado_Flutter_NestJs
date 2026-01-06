import {
  Controller,
  Post,
  Get,
  Patch,
  Param,
  Body,
  UseGuards,
  Req,
  ParseIntPipe,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiParam,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../../auth/presentation/guards/jwt-auth.guard';
import { CreateOrderRequestDto } from '../../application/dto/request/create-order.request.dto';
import { UpdateOrderStatusRequestDto } from '../../application/dto/request/update-order-status.request.dto';
import { OrderResponseDto } from '../../application/dto/response/order.response.dto';
import { DeliveryStatsResponseDto } from '../../application/dto/response/delivery-stats.response.dto';
import { CreateOrderUseCase } from '../../application/use_cases/create-order.use-case';
import { GetOrderByIdUseCase } from '../../application/use_cases/get-order-by-id.use-case';
import { GetUserOrdersUseCase } from '../../application/use_cases/get-user-orders.use-case';
import { UpdateOrderStatusUseCase } from '../../application/use_cases/update-order-status.use-case';
import { GetDeliveryStatsUseCase } from '../../application/use_cases/get-delivery-stats.use-case';

@ApiTags('Orders')
@ApiBearerAuth()
@Controller('orders')
@UseGuards(JwtAuthGuard)
export class OrdersController {
  constructor(
    private readonly createOrderUseCase: CreateOrderUseCase,
    private readonly getOrderByIdUseCase: GetOrderByIdUseCase,
    private readonly getUserOrdersUseCase: GetUserOrdersUseCase,
    private readonly updateOrderStatusUseCase: UpdateOrderStatusUseCase,
    private readonly getDeliveryStatsUseCase: GetDeliveryStatsUseCase,
  ) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ 
    summary: 'Crear un nuevo pedido',
    description: 'Crea un nuevo pedido con los items del carrito del usuario autenticado',
  })
  @ApiResponse({
    status: 201,
    description: 'Pedido creado exitosamente',
    type: OrderResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Datos de entrada inválidos' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async createOrder(@Req() req: any, @Body() dto: CreateOrderRequestDto): Promise<OrderResponseDto> {
    const userId = Number(req.user.sub);
    return await this.createOrderUseCase.execute(userId, dto);
  }

  @Get()
  @ApiOperation({ 
    summary: 'Obtener todos los pedidos del usuario',
    description: 'Lista todos los pedidos realizados por el usuario autenticado',
  })
  @ApiResponse({
    status: 200,
    description: 'Lista de pedidos recuperada exitosamente',
    type: [OrderResponseDto],
  })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async getUserOrders(@Req() req: any): Promise<OrderResponseDto[]> {
    const userId = Number(req.user.sub);
    return await this.getUserOrdersUseCase.execute(userId);
  }

  @Get('stats/delivery')
  @ApiOperation({ 
    summary: 'Obtener estadísticas de entregas',
    description: 'Obtiene estadísticas de pedidos y entregas del usuario autenticado',
  })
  @ApiResponse({
    status: 200,
    description: 'Estadísticas recuperadas exitosamente',
    type: DeliveryStatsResponseDto,
  })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async getDeliveryStats(@Req() req: any): Promise<DeliveryStatsResponseDto> {
    const userId = Number(req.user.sub);
    return await this.getDeliveryStatsUseCase.execute(userId);
  }

  @Get(':id')
  @ApiOperation({ 
    summary: 'Obtener un pedido por ID',
    description: 'Recupera los detalles de un pedido específico',
  })
  @ApiParam({ name: 'id', description: 'ID del pedido', type: 'integer' })
  @ApiResponse({
    status: 200,
    description: 'Pedido recuperado exitosamente',
    type: OrderResponseDto,
  })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  @ApiResponse({ status: 404, description: 'Pedido no encontrado' })
  async getOrderById(@Param('id', ParseIntPipe) id: number): Promise<OrderResponseDto> {
    return await this.getOrderByIdUseCase.execute(id);
  }

  @Patch(':id/status')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ 
    summary: 'Actualizar el estado de un pedido',
    description: 'Actualiza el estado de un pedido existente',
  })
  @ApiParam({ name: 'id', description: 'ID del pedido', type: 'integer' })
  @ApiResponse({
    status: 200,
    description: 'Estado actualizado exitosamente',
  })
  @ApiResponse({ status: 400, description: 'Estado inválido o transición no permitida' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  @ApiResponse({ status: 404, description: 'Pedido no encontrado' })
  async updateOrderStatus(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateOrderStatusRequestDto,
  ): Promise<{ message: string }> {
    await this.updateOrderStatusUseCase.execute(id, dto.status);
    return { message: 'Estado actualizado correctamente' };
  }
}
