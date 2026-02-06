class LoyaltyRedemption {
  final int id;
  final int userId;
  final int ruleId;
  final int rescueMenuId;
  final String rescueMenuName;
  final int? orderId;
  final DateTime redeemedAt;
  final bool isActive;

  const LoyaltyRedemption({
    required this.id,
    required this.userId,
    required this.ruleId,
    required this.rescueMenuId,
    required this.rescueMenuName,
    this.orderId,
    required this.redeemedAt,
    required this.isActive,
  });

  factory LoyaltyRedemption.fromJson(Map<String, dynamic> json) {
    return LoyaltyRedemption(
      id: json['id'] as int,
      userId: json['userId'] as int,
      ruleId: json['ruleId'] as int,
      rescueMenuId: json['rescueMenuId'] as int,
      rescueMenuName: json['rescueMenuName'] as String,
      orderId: json['orderId'] as int?,
      redeemedAt: DateTime.parse(json['redeemedAt'] as String),
      isActive: json['isActive'] is int 
          ? json['isActive'] == 1 
          : json['isActive'] as bool,
    );
  }
}
