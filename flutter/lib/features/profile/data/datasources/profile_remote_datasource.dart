import 'package:dio/dio.dart';
import 'package:eco_bocado/core/utils/app_services.dart';
import 'package:eco_bocado/core/utils/constants.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource();

  /// GET /api/profile/me
  /// Obtiene el perfil del usuario/admin autenticado
  Future<Map<String, dynamic>> getProfile() async {
    final response = await AppServices.dio.get('/profile/me');
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /api/profile/update
  /// Actualiza el perfil del usuario/admin autenticado
  Future<Map<String, dynamic>> updateProfile({
    String? phone,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? postalCode,
    String? countryCode,
    String? avatarUrl,
  }) async {
    final body = <String, dynamic>{};
    
    if (phone != null) body['phone'] = phone;
    if (addressLine1 != null) body['addressLine1'] = addressLine1;
    if (addressLine2 != null) body['addressLine2'] = addressLine2;
    if (city != null) body['city'] = city;
    if (postalCode != null) body['postalCode'] = postalCode;
    if (countryCode != null) body['countryCode'] = countryCode;
    if (avatarUrl != null) body['avatarUrl'] = avatarUrl;

    final response = await AppServices.dio.patch('/profile/update', data: body);
    return response.data as Map<String, dynamic>;
  }

  /// POST /api/profile/avatar
  /// Sube una foto de perfil
  Future<Map<String, dynamic>> uploadAvatar(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      ),
    });

    final response = await AppServices.dio.post(
      '/profile/avatar',
      data: formData,
    );
    
    return response.data as Map<String, dynamic>;
  }

  /// PATCH /api/auth/password
  /// Cambia la contraseña del usuario autenticado (solo para role=user)
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await AppServices.dio.patch(
      '/auth/password',
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }

  /// POST /api/auth/logout (para users con refreshToken)
  /// POST /api/auth/admin/logout (para admins sin refreshToken)
  Future<void> logout() async {
    // Leer el role y refresh token desde secure storage
    final role = await AppServices.storage.read(key: authRoleKey);
    final isAdmin = role == 'admin';

    if (isAdmin) {
      // Admin logout: sin body
      await AppServices.dio.post('/auth/admin/logout');
    } else {
      // User logout: con refreshToken en body
      final refreshToken = await AppServices.storage.read(key: refreshKey);
      
      final body = <String, dynamic>{};
      if (refreshToken != null && refreshToken.isNotEmpty) {
        body['refreshToken'] = refreshToken;
      }

      await AppServices.dio.post('/auth/logout', data: body);
    }
  }
}
