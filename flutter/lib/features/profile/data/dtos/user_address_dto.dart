class CreateUserAddressDto {
  final String label;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String? stateProvince;
  final String postalCode;
  final String? country;
  final String? phone;
  final bool? isDefault;

  CreateUserAddressDto({
    required this.label,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    this.stateProvince,
    required this.postalCode,
    this.country,
    this.phone,
    this.isDefault,
  });

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'addressLine1': addressLine1,
      if (addressLine2 != null) 'addressLine2': addressLine2,
      'city': city,
      if (stateProvince != null) 'stateProvince': stateProvince,
      'postalCode': postalCode,
      if (country != null) 'country': country,
      if (phone != null) 'phone': phone,
      if (isDefault != null) 'isDefault': isDefault,
    };
  }
}

class UpdateUserAddressDto {
  final String? label;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? stateProvince;
  final String? postalCode;
  final String? country;
  final String? phone;

  UpdateUserAddressDto({
    this.label,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.stateProvince,
    this.postalCode,
    this.country,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (label != null) map['label'] = label;
    if (addressLine1 != null) map['addressLine1'] = addressLine1;
    if (addressLine2 != null) map['addressLine2'] = addressLine2;
    if (city != null) map['city'] = city;
    if (stateProvince != null) map['stateProvince'] = stateProvince;
    if (postalCode != null) map['postalCode'] = postalCode;
    if (country != null) map['country'] = country;
    if (phone != null) map['phone'] = phone;
    return map;
  }
}
