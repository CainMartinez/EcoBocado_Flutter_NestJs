import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_address.dart';
import '../../data/datasources/user_address_api_client.dart';
import '../../data/dtos/user_address_dto.dart';

/// Provider para el API client de direcciones
final userAddressApiClientProvider = Provider<UserAddressApiClient>((ref) {
  return UserAddressApiClient();
});

/// Provider principal para la lista de direcciones del usuario
final userAddressesProvider =
    AsyncNotifierProvider<UserAddressesNotifier, List<UserAddress>>(
  () => UserAddressesNotifier(),
);

/// Notifier para manejar el estado de las direcciones
class UserAddressesNotifier extends AsyncNotifier<List<UserAddress>> {
  @override
  Future<List<UserAddress>> build() async {
    final apiClient = ref.read(userAddressApiClientProvider);
    return await apiClient.getAddresses();
  }

  /// Refresca las direcciones desde el servidor
  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final apiClient = ref.read(userAddressApiClientProvider);
      final addresses = await apiClient.getAddresses();
      state = AsyncValue.data(addresses);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Crea una nueva dirección
  Future<UserAddress?> createAddress(CreateUserAddressDto dto) async {
    try {
      final apiClient = ref.read(userAddressApiClientProvider);
      final newAddress = await apiClient.createAddress(dto);

      // Actualización optimista de la lista
      final currentAddresses = state.value ?? [];
      state = AsyncValue.data([...currentAddresses, newAddress]);

      return newAddress;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  /// Actualiza una dirección existente
  Future<bool> updateAddress(int addressId, UpdateUserAddressDto dto) async {
    try {
      final apiClient = ref.read(userAddressApiClientProvider);
      final updatedAddress = await apiClient.updateAddress(addressId, dto);

      // Actualizar en la lista local
      final currentAddresses = state.value ?? [];
      final updatedList = currentAddresses.map((address) {
        return address.id == addressId ? updatedAddress : address;
      }).toList();

      state = AsyncValue.data(updatedList);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Elimina una dirección (soft delete)
  Future<bool> deleteAddress(int addressId) async {
    try {
      final apiClient = ref.read(userAddressApiClientProvider);
      await apiClient.deleteAddress(addressId);

      // Remover de la lista local
      final currentAddresses = state.value ?? [];
      final updatedList =
          currentAddresses.where((address) => address.id != addressId).toList();

      state = AsyncValue.data(updatedList);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Establece una dirección como predeterminada
  Future<bool> setAsDefault(int addressId) async {
    try {
      final apiClient = ref.read(userAddressApiClientProvider);
      await apiClient.setAsDefault(addressId);

      // Recargar las direcciones desde el servidor para obtener el estado actualizado
      await refresh();
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Obtiene la dirección predeterminada del usuario
  UserAddress? getDefaultAddress() {
    final addresses = state.value ?? [];
    try {
      return addresses.firstWhere((address) => address.isDefault);
    } catch (e) {
      return null;
    }
  }
}
