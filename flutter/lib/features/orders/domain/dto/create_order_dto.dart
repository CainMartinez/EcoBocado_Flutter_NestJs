/// DTO para crear un item en una orden
class CreateOrderItemDto {
  final String itemType; // 'product' o 'menu'
  final int itemId;
  final double quantity;
  final double unitPrice;

  const CreateOrderItemDto({
    required this.itemType,
    required this.itemId,
    required this.quantity,
    required this.unitPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemType': itemType,
      'itemId': itemId,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }
}

/// DTO para crear una orden
class CreateOrderDto {
  final String deliveryType; // 'pickup' o 'delivery'
  final List<CreateOrderItemDto> items;
  
  // Campos para pickup
  final int? pickupSlotId;
  final String? pickupDate; // 'YYYY-MM-DD'
  final String? pickupStartTime; // 'HH:MM:SS'
  final String? pickupEndTime; // 'HH:MM:SS'
  final int? venueId;
  
  // Campos para delivery
  final int? userAddressId;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? stateProvince;
  final String? postalCode;
  final String? country;
  final String? phone;
  final String? deliveryNotes;
  final String? estimatedDeliveryDate; // 'YYYY-MM-DD'
  final String? estimatedDeliveryTime; // 'HH:MM:SS'
  
  // Comunes
  final String? notes;
  final String? paymentIntentId;

  const CreateOrderDto({
    required this.deliveryType,
    required this.items,
    this.pickupSlotId,
    this.pickupDate,
    this.pickupStartTime,
    this.pickupEndTime,
    this.venueId,
    this.userAddressId,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.stateProvince,
    this.postalCode,
    this.country,
    this.phone,
    this.deliveryNotes,
    this.estimatedDeliveryDate,
    this.estimatedDeliveryTime,
    this.notes,
    this.paymentIntentId,
  });

  Map<String, dynamic> toJson() {
    return {
      'deliveryType': deliveryType,
      'items': items.map((item) => item.toJson()).toList(),
      
      // Pickup fields
      if (pickupSlotId != null) 'pickupSlotId': pickupSlotId,
      if (pickupDate != null) 'pickupDate': pickupDate,
      if (pickupStartTime != null) 'pickupStartTime': pickupStartTime,
      if (pickupEndTime != null) 'pickupEndTime': pickupEndTime,
      if (venueId != null) 'venueId': venueId,
      
      // Delivery fields
      if (userAddressId != null) 'userAddressId': userAddressId,
      if (addressLine1 != null) 'addressLine1': addressLine1,
      if (addressLine2 != null) 'addressLine2': addressLine2,
      if (city != null) 'city': city,
      if (stateProvince != null) 'stateProvince': stateProvince,
      if (postalCode != null) 'postalCode': postalCode,
      if (country != null) 'country': country,
      if (phone != null) 'phone': phone,
      if (deliveryNotes != null) 'deliveryNotes': deliveryNotes,
      if (estimatedDeliveryDate != null) 'estimatedDeliveryDate': estimatedDeliveryDate,
      if (estimatedDeliveryTime != null) 'estimatedDeliveryTime': estimatedDeliveryTime,
      
      // Common fields
      if (notes != null) 'notes': notes,
      if (paymentIntentId != null) 'paymentIntentId': paymentIntentId,
    };
  }
}
