import 'package:flutter/material.dart';

/// Alérgeno
class Allergen {
  final String code;
  final String nameEs;
  final String nameEn;
  final bool contains;
  final bool mayContain;

  const Allergen({
    required this.code,
    required this.nameEs,
    required this.nameEn,
    this.contains = false,
    this.mayContain = false,
  });

  /// Retorna el nombre según el idioma del contexto
  String displayName(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'en' ? nameEn : nameEs;
  }
  
  /// Retorna el nombre sin contexto (usa español por defecto)
  String get name => nameEs;

  factory Allergen.fromJson(Map<String, dynamic> json) {
    return Allergen(
      code: json['code'] as String,
      nameEs: json['nameEs'] as String,
      nameEn: json['nameEn'] as String,
      contains: _parseBool(json['contains']),
      mayContain: _parseBool(json['mayContain']),
    );
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    return false;
  }
}
