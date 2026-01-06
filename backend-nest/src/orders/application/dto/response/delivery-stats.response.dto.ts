import { ApiProperty } from '@nestjs/swagger';

export class DeliveryStatsResponseDto {
  @ApiProperty({ description: 'Pedidos pendientes para hoy', example: 3 })
  todayPending: number;

  @ApiProperty({ description: 'Pedidos en marcha hoy', example: 2 })
  todayInProgress: number;

  @ApiProperty({ description: 'Pedidos completados hoy', example: 5 })
  todayCompleted: number;

  @ApiProperty({ description: 'Total de pedidos completados', example: 124 })
  totalCompleted: number;

  @ApiProperty({ description: 'Pedidos completados esta semana', example: 15 })
  weekCompleted: number;

  @ApiProperty({ description: 'Pedidos completados este mes', example: 42 })
  monthCompleted: number;

  @ApiProperty({ description: 'Ingresos totales acumulados', example: 3245.50 })
  totalRevenue: number;
}
