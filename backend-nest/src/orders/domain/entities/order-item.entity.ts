export type OrderItemType = 'product' | 'rescue_menu';

export class OrderItem {
  readonly id: number;
  readonly orderId: number;

  readonly itemType: OrderItemType;     // 'product' | 'rescue_menu'
  readonly productId: number | null;    // si itemType === 'product'
  readonly rescueMenuId: number | null; // si itemType === 'rescue_menu'

  readonly quantity: number;            // DECIMAL(10,2) en BD
  readonly unitPrice: number;           // DECIMAL(10,2)
  readonly lineTotal: number;           // DECIMAL(10,2)

  readonly itemName?: string;           // Nombre del producto o menú

  readonly isActive: boolean;

  readonly createdAt: Date;
  readonly updatedAt: Date;

  constructor(props: {
    id: number;
    orderId: number;
    itemType: OrderItemType;
    productId: number | null;
    rescueMenuId: number | null;
    quantity: number;
    unitPrice: number;
    lineTotal: number;
    itemName?: string;
    isActive: boolean;
    createdAt: Date;
    updatedAt: Date;
  }) {
    this.id = props.id;
    this.orderId = props.orderId;

    this.itemType = props.itemType;
    this.productId = props.productId ?? null;
    this.rescueMenuId = props.rescueMenuId ?? null;

    this.quantity = props.quantity;
    this.unitPrice = props.unitPrice;
    this.lineTotal = props.lineTotal;

    this.itemName = props.itemName;

    this.isActive = props.isActive;

    this.createdAt = props.createdAt;
    this.updatedAt = props.updatedAt;
  }

  static fromPrimitives(p: {
    id: number;
    orderId: number;
    itemType: OrderItemType;
    productId: number | null;
    rescueMenuId: number | null;
    quantity: number;
    unitPrice: number;
    lineTotal: number;
    itemName?: string;
    isActive: boolean;
    createdAt: Date;
    updatedAt: Date;
  }): OrderItem {
    return new OrderItem({
      id: p.id,
      orderId: p.orderId,
      itemType: p.itemType,
      productId: p.productId ?? null,
      rescueMenuId: p.rescueMenuId ?? null,
      quantity: p.quantity,
      unitPrice: p.unitPrice,
      lineTotal: p.lineTotal,
      itemName: p.itemName,
      isActive: p.isActive,
      createdAt: p.createdAt,
      updatedAt: p.updatedAt,
    });
  }
}