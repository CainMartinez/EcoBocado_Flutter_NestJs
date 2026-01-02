import { Inject, Injectable, BadRequestException } from '@nestjs/common';
import * as OrderRepo from '../../domain/repositories/order.repository.interface';
import * as PaymentRepo from '../../../payment/domain/repositories/payment.repository.interface';
import { DELIVERY_REPOSITORY_TOKEN } from '../../../delivery/domain/repositories/delivery.repository.interface';
import type { IDeliveryRepository } from '../../../delivery/domain/repositories/delivery.repository.interface';
import { USER_ADDRESS_REPOSITORY_TOKEN } from '../../../profile/domain/repositories/user-address.repository.interface';
import type { IUserAddressRepository } from '../../../profile/domain/repositories/user-address.repository.interface';
import { CreateOrderRequestDto } from '../dto/request/create-order.request.dto';
import { OrderResponseDto } from '../dto/response/order.response.dto';
import { OrderItemResponseDto } from '../dto/response/order-item.response.dto';
import { CreateInvoiceForOrderUseCase } from '../../../billing/application/use_cases/create-invoice-for-order.usecase';

@Injectable()
export class CreateOrderUseCase {
  constructor(
    @Inject(OrderRepo.ORDER_REPOSITORY_TOKEN)
    private readonly orderRepository: OrderRepo.IOrderRepository,
    @Inject(PaymentRepo.PAYMENT_REPOSITORY_TOKEN)
    private readonly paymentRepository: PaymentRepo.IPaymentRepository,
    @Inject(DELIVERY_REPOSITORY_TOKEN)
    private readonly deliveryRepository: IDeliveryRepository,
    @Inject(USER_ADDRESS_REPOSITORY_TOKEN)
    private readonly userAddressRepository: IUserAddressRepository,
    private readonly createInvoiceForOrderUseCase: CreateInvoiceForOrderUseCase,
  ) {}

  async execute(userId: number, dto: CreateOrderRequestDto): Promise<OrderResponseDto> {
    // Si viene paymentIntentId, validar que el pago existe y está succeeded
    if (dto.paymentIntentId) {
      const payment = await this.paymentRepository.findByPaymentIntentId(dto.paymentIntentId);
      if (!payment) {
        throw new BadRequestException('Payment intent not found');
      }
      if (payment.status !== 'succeeded') {
        throw new BadRequestException(`Payment is not completed. Current status: ${payment.status}`);
      }
      if (payment.userId !== userId) {
        throw new BadRequestException('Payment does not belong to this user');
      }
    }

    // Si es delivery y viene userAddressId, validar que la dirección existe y pertenece al usuario
    if (dto.deliveryType === 'delivery' && dto.userAddressId) {
      const userAddress = await this.userAddressRepository.findById(dto.userAddressId);
      if (!userAddress) {
        throw new BadRequestException('User address not found');
      }
      if (userAddress.userId !== userId) {
        throw new BadRequestException('Address does not belong to this user');
      }
    }

    const { order, items } = await this.orderRepository.createOrder(
      userId,
      dto.items.map((item) => ({
        itemType: item.itemType,
        itemId: item.itemId,
        quantity: item.quantity,
        unitPrice: item.unitPrice,
      })),
      {
        deliveryType: dto.deliveryType,
        pickupSlotId: dto.pickupSlotId,
        pickupDate: dto.pickupDate,
        pickupStartTime: dto.pickupStartTime,
        pickupEndTime: dto.pickupEndTime,
        venueId: dto.venueId,
        notes: dto.notes,
        paymentIntentId: dto.paymentIntentId,
      },
    );

    // Si es delivery, crear el registro de delivery
    if (dto.deliveryType === 'delivery') {
      let deliveryData: any = {
        orderId: order.id,
        userAddressId: dto.userAddressId,
        deliveryNotes: dto.deliveryNotes,
        estimatedDeliveryDate: dto.estimatedDeliveryDate ? new Date(dto.estimatedDeliveryDate) : undefined,
        estimatedDeliveryTimeStart: dto.estimatedDeliveryTime,
        estimatedDeliveryTimeEnd: dto.estimatedDeliveryTime,
      };

      // Si viene userAddressId, obtener los datos de la dirección guardada
      if (dto.userAddressId) {
        const userAddress = await this.userAddressRepository.findById(dto.userAddressId);
        if (userAddress) {
          deliveryData = {
            ...deliveryData,
            addressLine1: userAddress.addressLine1,
            addressLine2: userAddress.addressLine2 ?? undefined,
            city: userAddress.city,
            stateProvince: userAddress.stateProvince ?? undefined,
            postalCode: userAddress.postalCode,
            country: userAddress.country,
            phone: userAddress.phone ?? dto.deliveryPhone ?? '',
          };
        }
      } else {
        // Dirección temporal proporcionada directamente
        deliveryData = {
          ...deliveryData,
          addressLine1: dto.addressLine1!,
          addressLine2: dto.addressLine2,
          city: dto.city!,
          stateProvince: dto.stateProvince,
          postalCode: dto.postalCode!,
          country: dto.country ?? 'España',
          phone: dto.deliveryPhone || '',
        };
        
        console.log('DEBUG - Datos de delivery temporal:', JSON.stringify(deliveryData, null, 2));
      }

      await this.deliveryRepository.create(deliveryData);
    }

    // Crear factura automáticamente para el pedido completado
    if (order.status === 'confirmed' || order.status === 'delivered') {
      try {
        await this.createInvoiceForOrderUseCase.execute(
          order.id,
          userId,
          parseFloat(order.total.toString()),
        );
      } catch (error) {
        console.error('Error creating invoice for order:', error);
        // No lanzamos error para no bloquear la creación del pedido
      }
    }

    return this.toResponseDto(order, items);
  }

  private toResponseDto(order: any, items: any[]): OrderResponseDto {
    return {
      id: order.id,
      uuid: order.uuid,
      userId: order.userId,
      status: order.status,
      pickupSlotId: order.pickupSlotId,
      paymentIntentId: order.paymentIntentId,
      subtotal: order.subtotal,
      total: order.total,
      currency: order.currency,
      notes: order.notes,
      items: items.map((item) => ({
        id: item.id,
        itemType: item.itemType,
        productId: item.productId,
        rescueMenuId: item.rescueMenuId,
        quantity: item.quantity,
        unitPrice: item.unitPrice,
        lineTotal: item.lineTotal,
        createdAt: item.createdAt,
        updatedAt: item.updatedAt,
      })),
      createdAt: order.createdAt,
      updatedAt: order.updatedAt,
    };
  }
}
