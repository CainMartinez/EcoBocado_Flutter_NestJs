import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/user_allergen_api_client.dart';

/// Provider para el API client de alérgenos del usuario
final userAllergenApiClientProvider = Provider<UserAllergenApiClient>((ref) {
  return UserAllergenApiClient();
});

/// Provider principal para los alérgenos del usuario
final userAllergensProvider =
    AsyncNotifierProvider<UserAllergensNotifier, List<String>>(
  () => UserAllergensNotifier(),
);

/// Notifier para manejar el estado de los alérgenos del usuario
class UserAllergensNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    final apiClient = ref.read(userAllergenApiClientProvider);
    return await apiClient.getUserAllergens();
  }

  /// Refresca los alérgenos desde el servidor
  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final apiClient = ref.read(userAllergenApiClientProvider);
      final allergens = await apiClient.getUserAllergens();
      state = AsyncValue.data(allergens);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Agrega un alérgeno al perfil del usuario
  Future<bool> addAllergen(String allergenCode) async {
    try {
      final apiClient = ref.read(userAllergenApiClientProvider);
      await apiClient.addAllergen(allergenCode);

      // Actualización optimista
      final currentAllergens = state.value ?? [];
      if (!currentAllergens.contains(allergenCode)) {
        state = AsyncValue.data([...currentAllergens, allergenCode]);
      }

      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Elimina un alérgeno del perfil del usuario
  Future<bool> removeAllergen(String allergenCode) async {
    try {
      final apiClient = ref.read(userAllergenApiClientProvider);
      await apiClient.removeAllergen(allergenCode);

      // Actualización optimista
      final currentAllergens = state.value ?? [];
      state = AsyncValue.data(
        currentAllergens.where((code) => code != allergenCode).toList(),
      );

      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Verifica si el usuario tiene un alérgeno específico
  bool hasAllergen(String allergenCode) {
    final allergens = state.value ?? [];
    return allergens.contains(allergenCode);
  }
}
