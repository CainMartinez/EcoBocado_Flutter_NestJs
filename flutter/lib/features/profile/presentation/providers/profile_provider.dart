import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eco_bocado/features/profile/domain/entities/profile.dart';
import 'package:eco_bocado/features/profile/domain/usecases/profile_usecases.dart';
import 'package:eco_bocado/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:eco_bocado/features/profile/data/repositories/profile_repository_impl.dart';

/// Provider para el remote datasource
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSource();
});

/// Provider para el repository
final profileRepositoryProvider = Provider((ref) {
  final remoteDataSource = ref.watch(profileRemoteDataSourceProvider);
  return ProfileRepositoryImpl(remoteDataSource);
});

/// Provider para los use cases
final profileUseCasesProvider = Provider((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileUseCases(repository);
});

/// Provider principal para el perfil
final profileProvider = AsyncNotifierProvider<ProfileNotifier, Profile>(
  () => ProfileNotifier(),
);

/// Notifier para manejar el estado del perfil
class ProfileNotifier extends AsyncNotifier<Profile> {
  @override
  Future<Profile> build() async {
    final useCases = ref.read(profileUseCasesProvider);
    return await useCases.getProfile();
  }

  /// Refresca el perfil desde el servidor
  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final useCases = ref.read(profileUseCasesProvider);
      final profile = await useCases.getProfile();
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Actualiza el perfil con actualización optimista
  Future<void> updateProfile({
    String? phone,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? postalCode,
    String? countryCode,
    String? avatarUrl,
  }) async {
    final previousState = state;
    final currentProfile = state.value;
    
    if (currentProfile == null) return;

    // Actualización optimista
    final updatedProfile = currentProfile.copyWith(
      phone: phone,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      city: city,
      postalCode: postalCode,
      countryCode: countryCode,
      avatarUrl: avatarUrl,
    );
    state = AsyncValue.data(updatedProfile);

    try {
      final useCases = ref.read(profileUseCasesProvider);
      final serverProfile = await useCases.updateProfile(
        phone: phone,
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        city: city,
        postalCode: postalCode,
        countryCode: countryCode,
        avatarUrl: avatarUrl,
      );
      state = AsyncValue.data(serverProfile);
    } catch (e, stack) {
      // Rollback en caso de error
      state = previousState;
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// Sube una foto de perfil
  Future<void> uploadAvatar(String filePath) async {
    try {
      final useCases = ref.read(profileUseCasesProvider);
      final profile = await useCases.uploadAvatar(filePath);
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// Cambia la contraseña del usuario
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final useCases = ref.read(profileUseCasesProvider);
    await useCases.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  /// Cierra sesión del usuario/admin
  Future<void> logout() async {
    final useCases = ref.read(profileUseCasesProvider);
    await useCases.logout();
    
    // Invalidar el estado del perfil
    ref.invalidateSelf();
  }
}
