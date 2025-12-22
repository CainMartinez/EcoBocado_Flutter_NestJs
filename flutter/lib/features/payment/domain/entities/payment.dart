class Payment {
  final int id;
  final String stripePaymentIntentId;
  final int? orderId;
  final int userId;
  final int amount;
  final String currency;
  final String status;
  final String? paymentMethod;
  final String? receiptUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Payment({
    required this.id,
    required this.stripePaymentIntentId,
    this.orderId,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.status,
    this.paymentMethod,
    this.receiptUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as int,
      stripePaymentIntentId: json['stripePaymentIntentId'] as String,
      orderId: json['orderId'] as int?,
      userId: json['userId'] as int,
      amount: json['amount'] as int,
      currency: json['currency'] as String,
      status: json['status'] as String,
      paymentMethod: json['paymentMethod'] as String?,
      receiptUrl: json['receiptUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stripePaymentIntentId': stripePaymentIntentId,
      'orderId': orderId,
      'userId': userId,
      'amount': amount,
      'currency': currency,
      'status': status,
      'paymentMethod': paymentMethod,
      'receiptUrl': receiptUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
