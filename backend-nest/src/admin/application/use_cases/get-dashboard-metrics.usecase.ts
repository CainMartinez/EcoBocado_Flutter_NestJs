import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { OrderOrmEntity } from '../../../orders/infrastructure/typeorm/entities-orm/order.orm-entity';
import { ProductOrmEntity } from '../../../shop/infrastructure/typeorm/entities-orm/product.orm-entity';
import { UsersOrmEntity } from '../../../auth/infrastructure/typeorm/entities-orm/users.orm-entity';
import { InvoiceOrmEntity } from '../../../billing/infrastructure/typeorm/entities-orm/invoice.orm-entity';
import { DashboardMetricsResponseDto } from '../dto/response/dashboard-metrics.response.dto';

@Injectable()
export class GetDashboardMetricsUseCase {
  constructor(
    @InjectRepository(OrderOrmEntity)
    private readonly orderRepository: Repository<OrderOrmEntity>,
    @InjectRepository(ProductOrmEntity)
    private readonly productRepository: Repository<ProductOrmEntity>,
    @InjectRepository(UsersOrmEntity)
    private readonly userRepository: Repository<UsersOrmEntity>,
    @InjectRepository(InvoiceOrmEntity)
    private readonly invoiceRepository: Repository<InvoiceOrmEntity>,
  ) {}

  async execute(): Promise<DashboardMetricsResponseDto> {
    // Total de pedidos
    const totalOrders = await this.orderRepository.count();

    // Ingresos totales (suma de todas las facturas emitidas)
    const revenueResult = await this.invoiceRepository
      .createQueryBuilder('invoice')
      .select('SUM(invoice.total)', 'total')
      .getRawOne();
    const totalRevenue = parseFloat(revenueResult?.total || '0');

    // Total de productos activos
    const totalProducts = await this.productRepository.count({
      where: { isActive: true },
    });

    // Total de usuarios
    const totalUsers = await this.userRepository.count();

    return {
      totalOrders,
      totalRevenue,
      totalProducts,
      totalUsers,
    };
  }
}
