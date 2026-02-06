class RescueMenu {
  final int id;
  final String? uuid;
  final String nameEs;
  final String nameEn;
  final String descriptionEs;
  final String descriptionEn;
  final ProductItem? drink;
  final ProductItem? starter;
  final ProductItem? main;
  final ProductItem? dessert;
  final double price;
  final String currency;
  final bool isVegan;
  final bool isActive;
  final List<String> allergens;

  const RescueMenu({
    required this.id,
    this.uuid,
    required this.nameEs,
    required this.nameEn,
    required this.descriptionEs,
    required this.descriptionEn,
    this.drink,
    this.starter,
    this.main,
    this.dessert,
    required this.price,
    required this.currency,
    required this.isVegan,
    required this.isActive,
    this.allergens = const [],
  });

  factory RescueMenu.fromJson(Map<String, dynamic> json) {
    return RescueMenu(
      id: json['id'] as int,
      uuid: json['uuid'] as String?,
      nameEs: json['nameEs'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
      descriptionEs: json['descriptionEs'] as String? ?? '',
      descriptionEn: json['descriptionEn'] as String? ?? '',
      drink: json['drink'] != null 
          ? ProductItem.fromJson(json['drink'] as Map<String, dynamic>)
          : null,
      starter: json['starter'] != null 
          ? ProductItem.fromJson(json['starter'] as Map<String, dynamic>)
          : null,
      main: json['main'] != null 
          ? ProductItem.fromJson(json['main'] as Map<String, dynamic>)
          : null,
      dessert: json['dessert'] != null 
          ? ProductItem.fromJson(json['dessert'] as Map<String, dynamic>)
          : null,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'EUR',
      isVegan: json['isVegan'] is int 
          ? json['isVegan'] == 1 
          : (json['isVegan'] as bool? ?? false),
      isActive: json['isActive'] is int 
          ? json['isActive'] == 1 
          : (json['isActive'] as bool? ?? true),
      allergens: (json['allergens'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }

  /// Obtiene el nombre según el idioma
  String name(String languageCode) {
    return languageCode == 'es' ? nameEs : nameEn;
  }

  /// Obtiene la descripción según el idioma
  String description(String languageCode) {
    return languageCode == 'es' ? descriptionEs : descriptionEn;
  }
}

/// Representa un item de producto dentro del menú de rescate
class ProductItem {
  final int id;
  final String nameEs;
  final String nameEn;
  final List<String> allergens;
  final List<String> images;

  const ProductItem({
    required this.id,
    required this.nameEs,
    required this.nameEn,
    this.allergens = const [],
    this.images = const [],
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['id'] as int,
      nameEs: json['nameEs'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
      allergens: (json['allergens'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }

  String name(String languageCode) {
    return languageCode == 'es' ? nameEs : nameEn;
  }
}
