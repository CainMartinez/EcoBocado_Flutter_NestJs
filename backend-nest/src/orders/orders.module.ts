import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { OrderOrmEntity } from './infrastructure/typeorm/entities-orm/order.orm-entity';
import { OrderItemOrmEntity } from './infrastructure/typeorm/entities-orm/order-item.orm-entity';
import { PickupSlotOrmEntity } from '../locations/infrastructure/typeorm/entities-orm/pickup-slot.orm-entity';
import { TypeOrmOrderRepository } from './infrastructure/typeorm/repositories/typeorm-order.repository';
import { ORDER_REPOSITORY_TOKEN } from './domain/repositories/order.repository.interface';
import { CreateOrderUseCase } from './application/use_cases/create-order.use-case';
import { GetOrderByIdUseCase } from './application/use_cases/get-order-by-id.use-case';
import { GetUserOrdersUseCase } from './application/use_cases/get-user-orders.use-case';
import { UpdateOrderStatusUseCase } from './application/use_cases/update-order-status.use-case';
import { OrdersController } from './presentation/controllers/orders.controller';
import { PaymentModule } from '../payment/payment.module';
import { DeliveryModule } from '../delivery/delivery.module';
import { ProfileModule } from '../profile/profile.module';
import { BillingModule } from '../billing/billing.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([OrderOrmEntity, OrderItemOrmEntity, PickupSlotOrmEntity]),
    PaymentModule,
    DeliveryModule,
    ProfileModule,
    BillingModule,
  ],
  controllers: [OrdersController],
  providers: [
    {
      provide: ORDER_REPOSITORY_TOKEN,
      useClass: TypeOrmOrderRepository,
    },
    CreateOrderUseCase,
    GetOrderByIdUseCase,
    GetUserOrdersUseCase,
    UpdateOrderStatusUseCase,
  ],
  exports: [ORDER_REPOSITORY_TOKEN],
})
export class OrdersModule {}