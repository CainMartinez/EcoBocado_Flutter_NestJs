class RecentOrder {
  final int id;
  final String uuid;
  final String customerName;
  final String orderType;
  final String status;
  final double totalAmount;
  final DateTime createdAt;

  const RecentOrder({
    required this.id,
    required this.uuid,
    required this.customerName,
    required this.orderType,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
  });

  factory RecentOrder.fromJson(Map<String, dynamic> json) {
    return RecentOrder(
      id: json['id'] as int,
      uuid: json['uuid'] as String,
      customerName: json['customerName'] as String,
      orderType: json['orderType'] as String,
      status: json['status'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
