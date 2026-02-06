import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/shop_api_client.dart';
import '../../domain/entities/rescue_menu.dart';
import '../../../profile/presentation/providers/user_allergens_provider.dart';

/// Provider para obtener los menús de rescate disponibles filtrados por alérgenos del usuario
final rescueMenusProvider = FutureProvider<List<RescueMenu>>((ref) async {
  final apiClient = ref.watch(shopApiClientProvider);
  final allMenus = await apiClient.getRescueMenus();
  
  // Obtener alérgenos del usuario para filtrar
  final userAllergensAsync = ref.watch(userAllergensProvider);
  final userAllergens = userAllergensAsync.value ?? [];
  
  // Si no tiene alérgenos configurados, devolver todos los menús
  if (userAllergens.isEmpty) {
    return allMenus;
  }
  
  // Filtrar menús que NO contengan los alérgenos del usuario
  return allMenus.where((menu) {
    // Si el menú tiene algún alérgeno del usuario, excluirlo
    return !menu.allergens.any((allergen) => userAllergens.contains(allergen));
  }).toList();
});

/// Provider del API client (ya existe en catalog_provider, lo reutilizamos)
final shopApiClientProvider = Provider<ShopApiClient>((ref) {
  return ShopApiClient();
});
