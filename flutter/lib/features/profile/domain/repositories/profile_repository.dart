import 'package:eco_bocado/features/profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile();
  
  Future<Profile> updateProfile({
    String? phone,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? postalCode,
    String? countryCode,
    String? avatarUrl,
  });
  
  Future<Profile> uploadAvatar(String filePath);
  
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  
  Future<void> logout();
}
