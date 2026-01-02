import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { OrderItemOrmEntity } from '../../../orders/infrastructure/typeorm/entities-orm/order-item.orm-entity';
import { TopProductResponseDto } from '../dto/response/top-product.response.dto';

@Injectable()
export class GetTopProductsUseCase {
  constructor(
    @InjectRepository(OrderItemOrmEntity)
    private readonly orderItemRepository: Repository<OrderItemOrmEntity>,
  ) {}

  async execute(limit: number = 10): Promise<TopProductResponseDto[]> {
    const topProducts = await this.orderItemRepository
      .createQueryBuilder('item')
      .select('item.product_id', 'id')
      .addSelect('product.name_es', 'nameEs')
      .addSelect('product.name_en', 'nameEn')
      .addSelect('SUM(item.quantity)', 'totalSold')
      .addSelect('SUM(item.line_total)', 'revenue')
      .innerJoin('item.product', 'product')
      .innerJoin('item.order', 'order')
      .where('order.status IN (:...statuses)', { 
        statuses: ['confirmed', 'prepared', 'delivered'] 
      })
      .andWhere('item.product_id IS NOT NULL')
      .groupBy('item.product_id')
      .addGroupBy('product.name_es')
      .addGroupBy('product.name_en')
      .orderBy('totalSold', 'DESC')
      .limit(limit)
      .getRawMany();

    return topProducts.map((product) => ({
      id: product.id,
      nameEs: product.nameEs,
      nameEn: product.nameEn,
      totalSold: parseInt(product.totalSold, 10),
      revenue: parseFloat(product.revenue),
    }));
  }
}
