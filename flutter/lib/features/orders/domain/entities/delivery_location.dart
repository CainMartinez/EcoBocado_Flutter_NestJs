class DeliveryLocation {
  final int deliveryUserId;
  final int? orderId;
  final double latitude;
  final double longitude;
  final DateTime updatedAt;

  const DeliveryLocation({
    required this.deliveryUserId,
    this.orderId,
    required this.latitude,
    required this.longitude,
    required this.updatedAt,
  });

  factory DeliveryLocation.fromJson(Map<String, dynamic> json) {
    return DeliveryLocation(
      deliveryUserId: json['deliveryUserId'] as int,
      orderId: json['orderId'] as int?,
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deliveryUserId': deliveryUserId,
      'orderId': orderId,
      'latitude': latitude,
      'longitude': longitude,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
