enum DeliveryStatus {
  pending,
  assigned,
  preparing,
  inTransit,
  delivered,
  failed,
  cancelled;

  factory DeliveryStatus.fromString(String value) {
    switch (value) {
      case 'pending':
        return DeliveryStatus.pending;
      case 'assigned':
        return DeliveryStatus.assigned;
      case 'preparing':
        return DeliveryStatus.preparing;
      case 'in_transit':
        return DeliveryStatus.inTransit;
      case 'delivered':
        return DeliveryStatus.delivered;
      case 'failed':
        return DeliveryStatus.failed;
      case 'cancelled':
        return DeliveryStatus.cancelled;
      default:
        return DeliveryStatus.pending;
    }
  }

  String toBackendString() {
    switch (this) {
      case DeliveryStatus.pending:
        return 'pending';
      case DeliveryStatus.assigned:
        return 'assigned';
      case DeliveryStatus.preparing:
        return 'preparing';
      case DeliveryStatus.inTransit:
        return 'in_transit';
      case DeliveryStatus.delivered:
        return 'delivered';
      case DeliveryStatus.failed:
        return 'failed';
      case DeliveryStatus.cancelled:
        return 'cancelled';
    }
  }
}

class Delivery {
  final int id;
  final int orderId;
  final int? userAddressId;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String? stateProvince;
  final String postalCode;
  final String country;
  final String phone;
  final String? deliveryNotes;
  final DateTime? estimatedDeliveryDate;
  final String? estimatedDeliveryTimeStart;
  final String? estimatedDeliveryTimeEnd;
  final DeliveryStatus deliveryStatus;
  final int? driverId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Delivery({
    required this.id,
    required this.orderId,
    this.userAddressId,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    this.stateProvince,
    required this.postalCode,
    required this.country,
    required this.phone,
    this.deliveryNotes,
    this.estimatedDeliveryDate,
    this.estimatedDeliveryTimeStart,
    this.estimatedDeliveryTimeEnd,
    required this.deliveryStatus,
    this.driverId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['id'] as int,
      orderId: json['orderId'] as int,
      userAddressId: json['userAddressId'] as int?,
      addressLine1: json['addressLine1'] as String,
      addressLine2: json['addressLine2'] as String?,
      city: json['city'] as String,
      stateProvince: json['stateProvince'] as String?,
      postalCode: json['postalCode'] as String,
      country: json['country'] as String,
      phone: json['phone'] as String,
      deliveryNotes: json['deliveryNotes'] as String?,
      estimatedDeliveryDate: json['estimatedDeliveryDate'] != null
          ? DateTime.parse(json['estimatedDeliveryDate'] as String)
          : null,
      estimatedDeliveryTimeStart: json['estimatedDeliveryTimeStart'] as String?,
      estimatedDeliveryTimeEnd: json['estimatedDeliveryTimeEnd'] as String?,
      deliveryStatus: DeliveryStatus.fromString(json['deliveryStatus'] as String),
      driverId: json['driverId'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'userAddressId': userAddressId,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'stateProvince': stateProvince,
      'postalCode': postalCode,
      'country': country,
      'phone': phone,
      'deliveryNotes': deliveryNotes,
      'estimatedDeliveryDate': estimatedDeliveryDate?.toIso8601String(),
      'estimatedDeliveryTimeStart': estimatedDeliveryTimeStart,
      'estimatedDeliveryTimeEnd': estimatedDeliveryTimeEnd,
      'deliveryStatus': deliveryStatus.toBackendString(),
      'driverId': driverId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String get fullAddress {
    final parts = <String>[
      addressLine1,
      if (addressLine2 != null && addressLine2!.isNotEmpty) addressLine2!,
      city,
      postalCode,
    ];
    return parts.join(', ');
  }

  String? get estimatedTimeRange {
    if (estimatedDeliveryTimeStart != null && estimatedDeliveryTimeEnd != null) {
      return '$estimatedDeliveryTimeStart - $estimatedDeliveryTimeEnd';
    }
    return null;
  }
}
