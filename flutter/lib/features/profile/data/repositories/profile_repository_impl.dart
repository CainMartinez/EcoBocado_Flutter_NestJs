import 'package:eco_bocado/core/utils/app_services.dart';
import 'package:eco_bocado/core/utils/constants.dart';
import 'package:eco_bocado/features/profile/domain/entities/profile.dart';
import 'package:eco_bocado/features/profile/domain/repositories/profile_repository.dart';
import 'package:eco_bocado/features/profile/data/datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Profile> getProfile() async {
    final data = await _remoteDataSource.getProfile();
    return Profile.fromJson(data);
  }

  @override
  Future<Profile> updateProfile({
    String? phone,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? postalCode,
    String? countryCode,
    String? avatarUrl,
  }) async {
    final data = await _remoteDataSource.updateProfile(
      phone: phone,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      city: city,
      postalCode: postalCode,
      countryCode: countryCode,
      avatarUrl: avatarUrl,
    );
    
    return Profile.fromJson(data);
  }

  @override
  Future<Profile> uploadAvatar(String filePath) async {
    final data = await _remoteDataSource.uploadAvatar(filePath);
    return Profile.fromJson(data);
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _remoteDataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<void> logout() async {
    // Llamar al endpoint de logout apropiado
    await _remoteDataSource.logout();
    
    // Limpiar todo el storage local
    await AppServices.storage.delete(key: tokenKey);
    await AppServices.storage.delete(key: refreshKey);
    await AppServices.storage.delete(key: authRoleKey);
    await AppServices.storage.delete(key: 'auth_session_name');
    await AppServices.storage.delete(key: 'auth_session_email');
    await AppServices.storage.delete(key: 'auth_session_avatar');
  }
}
