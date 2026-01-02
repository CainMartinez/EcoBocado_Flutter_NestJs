import 'package:eco_bocado/features/profile/domain/entities/profile.dart';
import 'package:eco_bocado/features/profile/domain/repositories/profile_repository.dart';

class ProfileUseCases {
  final ProfileRepository _repository;

  ProfileUseCases(this._repository);

  Future<Profile> getProfile() => _repository.getProfile();

  Future<Profile> updateProfile({
    String? phone,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? postalCode,
    String? countryCode,
    String? avatarUrl,
  }) =>
      _repository.updateProfile(
        phone: phone,
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        city: city,
        postalCode: postalCode,
        countryCode: countryCode,
        avatarUrl: avatarUrl,
      );

  Future<Profile> uploadAvatar(String filePath) => _repository.uploadAvatar(filePath);

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

  Future<void> logout() => _repository.logout();
}
