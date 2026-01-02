class TopProduct {
  final int id;
  final String nameEs;
  final String nameEn;
  final int totalSold;
  final double revenue;

  const TopProduct({
    required this.id,
    required this.nameEs,
    required this.nameEn,
    required this.totalSold,
    required this.revenue,
  });

  String name(String languageCode) {
    return languageCode == 'en' ? nameEn : nameEs;
  }

  factory TopProduct.fromJson(Map<String, dynamic> json) {
    return TopProduct(
      id: json['id'] as int,
      nameEs: json['nameEs'] as String,
      nameEn: json['nameEn'] as String,
      totalSold: json['totalSold'] as int,
      revenue: (json['revenue'] as num).toDouble(),
    );
  }
}
