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
import { RankingResponseDto } from '../dto/response/ranking.response.dto';
import { CreateOrderUseCase } from '../../application/use_cases/create-order.use-case';
import { GetOrderByIdUseCase } from '../../application/use_cases/get-order-by-id.use-case';
import { GetUserOrdersUseCase } from '../../application/use_cases/get-user-orders.use-case';
import { UpdateOrderStatusUseCase } from '../../application/use_cases/update-order-status.use-case';
import { GetDeliveryStatsUseCase } from '../../application/use_cases/get-delivery-stats.use-case';
import { GetDeliveryRankingUseCase } from '../../application/use-cases/get-delivery-ranking.use-case';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { OrderOrmEntity } from '../../infrastructure/typeorm/entities-orm/order.orm-entity';

@ApiTags('Orders')
@ApiBearerAuth()
@Controller('orders')
@UseGuards(JwtAuthGuard)
export class OrdersController {
  constructor(
    private readonly createOrderUseCase: CreateOrderUseCase,
    private readonly getOrderByIdUseCase: GetOrderByIdUseCase,
    private readonly getUserOrdersUseCase: GetUserOrdersUseCase,
    @InjectRepository(OrderOrmEntity)
    private readonly orderRepository: Repository<OrderOrmEntity>,
    private readonly updateOrderStatusUseCase: UpdateOrderStatusUseCase,
    private readonly getDeliveryStatsUseCase: GetDeliveryStatsUseCase,
    private readonly getDeliveryRankingUseCase: GetDeliveryRankingUseCase,
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
    @Req() req: any,
  ): Promise<{ message: string }> {
    // Si el estado es "delivered", pasar el ID del usuario autenticado como driverId
    const driverId = dto.status === 'delivered' ? Number(req.user?.sub) : undefined;
    await this.updateOrderStatusUseCase.execute(id, dto.status, driverId);
    return { message: 'Estado actualizado correctamente' };
  }

  @Get('ranking/delivery')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ 
    summary: 'Obtener ranking de repartidores',
    description: 'Obtiene el ranking mensual de repartidores basado en pedidos completados. Solo el usuario actual verá su nombre, los demás aparecen anónimos.',
  })
  @ApiResponse({
    status: 200,
    description: 'Ranking recuperado exitosamente',
    type: RankingResponseDto,
  })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async getDeliveryRanking(@Req() req: any): Promise<RankingResponseDto> {
    const driverId = Number(req.user?.sub); // Convertir a número
    const result = await this.getDeliveryRankingUseCase.execute(driverId);
    return result;
  }

  @Get('ranking/debug')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ 
    summary: '[DEBUG] Ver todas las órdenes completadas del mes',
    description: 'Endpoint de debugging para ver todas las órdenes completadas del mes actual con su driverId',
  })
  @ApiResponse({ status: 200, description: 'Datos de debug' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async debugRanking(@Req() req: any): Promise<any> {
    const now = new Date();
    const currentMonth = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;
    
    const currentUserId = req.user?.sub; // El JWT usa 'sub' para el user ID
    
    // Ver órdenes completadas del mes
    const orders = await this.orderRepository.createQueryBuilder('order')
      .select(['order.id', 'order.status', 'order.driverId', 'order.updatedAt'])
      .where('order.status = :status', { status: 'completed' })
      .andWhere('DATE_FORMAT(order.updatedAt, "%Y-%m") = :currentMonth', { currentMonth })
      .getMany();

    return {
      currentMonth,
      currentUserId,
      totalCompletedOrders: orders.length,
      ordersWithDriver: orders.filter(o => o.driverId !== null).length,
      orders: orders,
    };
  }
}
