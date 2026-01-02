class BillingRecord {
  final int id;
  final String uuid;
  final String number;
  final int userId;
  final String customerName;
  final String customerEmail;
  final int orderId;
  final String orderUuid;
  final String status;
  final double total;
  final DateTime? issuedAt;
  final DateTime createdAt;

  const BillingRecord({
    required this.id,
    required this.uuid,
    required this.number,
    required this.userId,
    required this.customerName,
    required this.customerEmail,
    required this.orderId,
    required this.orderUuid,
    required this.status,
    required this.total,
    this.issuedAt,
    required this.createdAt,
  });

  factory BillingRecord.fromJson(Map<String, dynamic> json) {
    return BillingRecord(
      id: json['id'] as int,
      uuid: json['uuid'] as String,
      number: json['number'] as String,
      userId: json['userId'] as int,
      customerName: json['customerName'] as String,
      customerEmail: json['customerEmail'] as String,
      orderId: json['orderId'] as int,
      orderUuid: json['orderUuid'] as String,
      status: json['status'] as String,
      total: (json['total'] as num).toDouble(),
      issuedAt: json['issuedAt'] != null 
          ? DateTime.parse(json['issuedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
