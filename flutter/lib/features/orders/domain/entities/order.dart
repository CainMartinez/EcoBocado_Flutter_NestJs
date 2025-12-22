/// Modelo para un item de orden
class OrderItem {
  final int id;
  final String itemType;
  final int? productId;
  final int? rescueMenuId;
  final double quantity;
  final double unitPrice;
  final double lineTotal;
  final String? itemName;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderItem({
    required this.id,
    required this.itemType,
    this.productId,
    this.rescueMenuId,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    this.itemName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int,
      itemType: json['itemType'] as String,
      productId: json['productId'] as int?,
      rescueMenuId: json['rescueMenuId'] as int?,
      quantity: _parseDouble(json['quantity']),
      unitPrice: _parseDouble(json['unitPrice']),
      lineTotal: _parseDouble(json['lineTotal']),
      itemName: json['itemName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
  
  static double _parseDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.parse(value);
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemType': itemType,
      'productId': productId,
      'rescueMenuId': rescueMenuId,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'lineTotal': lineTotal,
      'itemName': itemName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// Modelo para una orden completa
class Order {
  final int id;
  final String? uuid;
  final int userId;
  final String status;
  final String deliveryType; // 'pickup' o 'delivery'
  final int? pickupSlotId;
  final String? paymentIntentId;
  final double subtotal;
  final double total;
  final String currency;
  final String? notes;
  final List<OrderItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Order({
    required this.id,
    this.uuid,
    required this.userId,
    required this.status,
    required this.deliveryType,
    this.pickupSlotId,
    this.paymentIntentId,
    required this.subtotal,
    required this.total,
    required this.currency,
    this.notes,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      uuid: json['uuid'] as String?,
      userId: json['userId'] as int,
      status: json['status'] as String,
      deliveryType: json['deliveryType'] as String? ?? 'pickup',
      pickupSlotId: json['pickupSlotId'] as int?,
      paymentIntentId: json['paymentIntentId'] as String?,
      subtotal: _parseDouble(json['subtotal']),
      total: _parseDouble(json['total']),
      currency: json['currency'] as String,
      notes: json['notes'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
  
  static double _parseDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.parse(value);
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'userId': userId,
      'status': status,
      'deliveryType': deliveryType,
      'pickupSlotId': pickupSlotId,
      'paymentIntentId': paymentIntentId,
      'subtotal': subtotal,
      'total': total,
      'currency': currency,
      'notes': notes,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
