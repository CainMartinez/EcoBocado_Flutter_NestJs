class UserAddress {
  final int id;
  final int userId;
  final String label;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String? stateProvince;
  final String postalCode;
  final String country;
  final String? phone;
  final bool isDefault;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserAddress({
    required this.id,
    required this.userId,
    required this.label,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    this.stateProvince,
    required this.postalCode,
    required this.country,
    this.phone,
    required this.isDefault,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      id: json['id'] as int,
      userId: json['userId'] as int,
      label: json['label'] as String,
      addressLine1: json['addressLine1'] as String,
      addressLine2: json['addressLine2'] as String?,
      city: json['city'] as String,
      stateProvince: json['stateProvince'] as String?,
      postalCode: json['postalCode'] as String,
      country: json['country'] as String,
      phone: json['phone'] as String?,
      isDefault: json['isDefault'] == true || json['isDefault'] == 1,
      isActive: json['isActive'] == true || json['isActive'] == 1,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'label': label,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'stateProvince': stateProvince,
      'postalCode': postalCode,
      'country': country,
      'phone': phone,
      'isDefault': isDefault,
      'isActive': isActive,
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
}
