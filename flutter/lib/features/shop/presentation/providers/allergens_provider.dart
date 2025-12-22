import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/allergen.dart';
import 'catalog_provider.dart';

/// Provider para la lista de alérgenos disponibles
final allergensProvider = FutureProvider<List<Allergen>>((ref) async {
  final apiClient = ref.watch(shopApiClientProvider);
  return await apiClient.getAllergens();
});
