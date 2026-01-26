import { ApiProperty } from '@nestjs/swagger';

export class DriverStatDto {
  @ApiProperty({
    description: 'ID del repartidor',
    example: 5,
  })
  driverId: number;

  @ApiProperty({
    description: 'Nombre del repartidor',
    example: 'Juan García',
  })
  driverName: string;

  @ApiProperty({
    description: 'Número total de pedidos completados',
    example: 42,
  })
  completedOrders: number;

  @ApiProperty({
    description: 'Tiempo promedio de entrega en minutos',
    example: 15.5,
  })
  averageDeliveryTime: number;
}

export class DriverStatsResponseDto {
  @ApiProperty({
    description: 'Top 3 repartidores más rápidos',
    type: [DriverStatDto],
  })
  topDrivers: DriverStatDto[];
}
