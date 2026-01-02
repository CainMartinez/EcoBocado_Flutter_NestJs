import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String ownerType; // 'user' | 'admin'
  final int ownerId;
  final String email;
  final String name;
  final String? avatarUrl;
  final String? phone;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? postalCode; // String para ser flexible con el backend
  final String? countryCode;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Profile({
    required this.ownerType,
    required this.ownerId,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.phone,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.postalCode,
    this.countryCode,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    try {
      
      // Convertir postalCode a String sin importar si viene como int o String
      String? postalCode;
      if (json['postalCode'] != null) {
        postalCode = json['postalCode'].toString();
      }

      // Convertir isActive de int (1/0) a bool
      bool isActive = true;
      if (json['isActive'] != null) {
        if (json['isActive'] is bool) {
          isActive = json['isActive'] as bool;
        } else if (json['isActive'] is int) {
          isActive = json['isActive'] == 1;
        }
      }

      // Campos required con validación
      final ownerType = json['ownerType']?.toString() ?? '';
      final ownerId = json['ownerId'] is int ? json['ownerId'] as int : int.tryParse(json['ownerId']?.toString() ?? '0') ?? 0;
      final email = json['email']?.toString() ?? '';
      final name = json['name']?.toString() ?? '';

      // Campos opcionales de tipo String con conversión segura
      final avatarUrl = json['avatarUrl']?.toString();
      final phone = json['phone']?.toString();
      final addressLine1 = json['addressLine1']?.toString();
      final addressLine2 = json['addressLine2']?.toString();
      final city = json['city']?.toString();
      final countryCode = json['countryCode']?.toString();

      return Profile(
        ownerType: ownerType,
        ownerId: ownerId,
        email: email,
        name: name,
        avatarUrl: avatarUrl,
        phone: phone,
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        city: city,
        postalCode: postalCode,
        countryCode: countryCode,
        isActive: isActive,
        createdAt: json['createdAt'] != null && json['createdAt'] is String
            ? DateTime.parse(json['createdAt'] as String)
            : null,
        updatedAt: json['updatedAt'] != null && json['updatedAt'] is String
            ? DateTime.parse(json['updatedAt'] as String)
            : null,
      );
    } catch (e) {
      rethrow;
    }
  }

  Profile copyWith({
    String? ownerType,
    int? ownerId,
    String? email,
    String? name,
    String? avatarUrl,
    String? phone,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? postalCode,
    String? countryCode,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Profile(
      ownerType: ownerType ?? this.ownerType,
      ownerId: ownerId ?? this.ownerId,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      countryCode: countryCode ?? this.countryCode,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isUser => ownerType == 'user';
  bool get isAdmin => ownerType == 'admin';

  String get fullAddress {
    final parts = <String>[];
    if (addressLine1 != null && addressLine1!.isNotEmpty) parts.add(addressLine1!);
    if (addressLine2 != null && addressLine2!.isNotEmpty) parts.add(addressLine2!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (postalCode != null && postalCode!.isNotEmpty) parts.add(postalCode!);
    return parts.join(', ');
  }

  @override
  List<Object?> get props => [
        ownerType,
        ownerId,
        email,
        name,
        avatarUrl,
        phone,
        addressLine1,
        addressLine2,
        city,
        postalCode,
        countryCode,
        isActive,
        createdAt,
        updatedAt,
      ];
}
