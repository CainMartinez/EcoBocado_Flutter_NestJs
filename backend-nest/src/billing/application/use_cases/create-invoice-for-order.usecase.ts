import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { InvoiceOrmEntity } from '../../infrastructure/typeorm/entities-orm/invoice.orm-entity';

@Injectable()
export class CreateInvoiceForOrderUseCase {
  constructor(
    @InjectRepository(InvoiceOrmEntity)
    private readonly invoiceRepository: Repository<InvoiceOrmEntity>,
  ) {}

  async execute(orderId: number, userId: number, total: number): Promise<InvoiceOrmEntity> {
    // Verificar si ya existe una factura para este pedido
    const existingInvoice = await this.invoiceRepository.findOne({
      where: { orderId },
    });

    if (existingInvoice) {
      return existingInvoice;
    }

    // Generar número de factura único
    const year = new Date().getFullYear();
    const count = await this.invoiceRepository.count();
    const invoiceNumber = `INV-${year}-${String(count + 1).padStart(3, '0')}`;

    // Crear factura con estado 'requested'
    const invoice = this.invoiceRepository.create({
      uuid: null,
      userId,
      orderId,
      number: invoiceNumber,
      status: 'requested',
      total,
      issuedAt: null,
      isActive: true,
      createdAt: new Date(),
      updatedAt: new Date(),
    });

    return await this.invoiceRepository.save(invoice);
  }
}
