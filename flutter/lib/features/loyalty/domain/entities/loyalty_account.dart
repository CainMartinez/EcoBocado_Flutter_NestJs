class LoyaltyAccount {
  final int id;
  final int userId;
  final int points;
  final int purchasesCount;
  final int purchasesUntilReward;
  final bool hasAvailableReward;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LoyaltyAccount({
    required this.id,
    required this.userId,
    required this.points,
    required this.purchasesCount,
    required this.purchasesUntilReward,
    required this.hasAvailableReward,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LoyaltyAccount.fromJson(Map<String, dynamic> json) {
    return LoyaltyAccount(
      id: json['id'] as int,
      userId: json['userId'] as int,
      points: json['points'] as int,
      purchasesCount: json['purchasesCount'] as int,
      purchasesUntilReward: json['purchasesUntilReward'] as int,
      hasAvailableReward: json['hasAvailableReward'] is bool 
          ? json['hasAvailableReward'] as bool
          : (json['hasAvailableReward'] as int) == 1,
      isActive: json['isActive'] is bool 
          ? json['isActive'] as bool
          : (json['isActive'] as int) == 1,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  double get progress {
    if (purchasesCount == 0) return 0.0;
    final totalForReward = purchasesCount + purchasesUntilReward;
    return purchasesCount / totalForReward;
  }
}
