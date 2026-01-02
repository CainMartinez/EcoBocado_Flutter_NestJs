import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { InvoiceOrmEntity } from '../../infrastructure/typeorm/entities-orm/invoice.orm-entity';
import { BillingRecordResponseDto } from '../dto/response/billing-record.response.dto';

@Injectable()
export class GetAllBillingRecordsUseCase {
  constructor(
    @InjectRepository(InvoiceOrmEntity)
    private readonly invoiceRepository: Repository<InvoiceOrmEntity>,
  ) {}

  async execute(): Promise<BillingRecordResponseDto[]> {
    const invoices = await this.invoiceRepository
      .createQueryBuilder('invoice')
      .leftJoinAndSelect('invoice.user', 'user')
      .leftJoinAndSelect('invoice.order', 'order')
      .orderBy('invoice.created_at', 'DESC')
      .getMany();

    return invoices.map((invoice) => ({
      id: invoice.id,
      uuid: invoice.uuid || '',
      number: invoice.number || '',
      userId: invoice.userId,
      customerName: invoice.user?.name || 'N/A',
      customerEmail: invoice.user?.email || 'N/A',
      orderId: invoice.orderId,
      orderUuid: invoice.order?.uuid || '',
      status: invoice.status,
      total: parseFloat(invoice.total.toString()),
      issuedAt: invoice.issuedAt,
      createdAt: invoice.createdAt,
    }));
  }
}
