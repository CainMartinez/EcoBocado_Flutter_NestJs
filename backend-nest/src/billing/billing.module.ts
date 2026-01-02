import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { InvoiceOrmEntity } from './infrastructure/typeorm/entities-orm/invoice.orm-entity';
import { OrderOrmEntity } from '../orders/infrastructure/typeorm/entities-orm/order.orm-entity';
import { UsersOrmEntity } from '../auth/infrastructure/typeorm/entities-orm/users.orm-entity';
import { BillingAdminController } from './presentation/controllers/billing-admin.controller';
import { GetAllBillingRecordsUseCase } from './application/use_cases/get-all-billing-records.usecase';
import { CreateInvoiceForOrderUseCase } from './application/use_cases/create-invoice-for-order.usecase';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      InvoiceOrmEntity,
      OrderOrmEntity,
      UsersOrmEntity,
    ]),
  ],
  controllers: [BillingAdminController],
  providers: [GetAllBillingRecordsUseCase, CreateInvoiceForOrderUseCase],
  exports: [CreateInvoiceForOrderUseCase],
})
export class BillingModule {}