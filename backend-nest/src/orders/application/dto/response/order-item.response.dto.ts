import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class OrderItemResponseDto {
  @ApiProperty({ description: 'ID del item del pedido', example: 1 })
  id: number;

  @ApiProperty({ 
    description: 'Tipo de item',
    enum: ['product', 'rescue_menu'],
    example: 'product',
  })
  itemType: 'product' | 'rescue_menu';

  @ApiPropertyOptional({ 
    description: 'ID del producto',
    example: 10,
    nullable: true,
  })
  productId: number | null;

  @ApiPropertyOptional({ 
    description: 'ID del menú',
    example: null,
    nullable: true,
  })
  rescueMenuId: number | null;

  @ApiProperty({ description: 'Cantidad', example: 2 })
  quantity: number;

  @ApiProperty({ description: 'Precio unitario', example: 9.99 })
  unitPrice: number;

  @ApiProperty({ description: 'Total de la línea', example: 19.98 })
  lineTotal: number;

  @ApiPropertyOptional({ 
    description: 'Nombre del producto o menú',
    example: 'Bocadillo de jamón',
  })
  itemName?: string;

  @ApiProperty({ description: 'Fecha de creación' })
  createdAt: Date;

  @ApiProperty({ description: 'Fecha de última actualización' })
  updatedAt: Date;
}
