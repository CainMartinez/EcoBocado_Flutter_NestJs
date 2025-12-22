import 'package:dio/dio.dart';
import '../../../../core/utils/app_services.dart';
import '../../domain/entities/user_address.dart';
import '../dtos/user_address_dto.dart';

/// Cliente API para gestión de direcciones de usuario
class UserAddressApiClient {
  final Dio _dio;

  UserAddressApiClient({Dio? dio}) : _dio = dio ?? AppServices.dio;

  /// POST /profile/addresses - Crea una nueva dirección
  Future<UserAddress> createAddress(CreateUserAddressDto dto) async {
    try {
      final response = await _dio.post(
        '/profile/addresses',
        data: dto.toJson(),
      );

      return UserAddress.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// GET /profile/addresses - Obtiene todas las direcciones del usuario
  Future<List<UserAddress>> getAddresses() async {
    try {
      final response = await _dio.get('/profile/addresses');

      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => UserAddress.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT /profile/addresses/:id - Actualiza una dirección existente
  Future<UserAddress> updateAddress(
      int addressId, UpdateUserAddressDto dto) async {
    try {
      final response = await _dio.put(
        '/profile/addresses/$addressId',
        data: dto.toJson(),
      );

      return UserAddress.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE /profile/addresses/:id - Elimina (soft delete) una dirección
  Future<void> deleteAddress(int addressId) async {
    try {
      await _dio.delete('/profile/addresses/$addressId');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PATCH /profile/addresses/:id/set-default - Establece dirección como predeterminada
  Future<void> setAsDefault(int addressId) async {
    try {
      await _dio.patch('/profile/addresses/$addressId/set-default');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Tiempo de espera agotado. Verifica tu conexión.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Error del servidor';
        return Exception('Error $statusCode: $message');
      case DioExceptionType.cancel:
        return Exception('Petición cancelada');
      default:
        return Exception('Error de conexión: ${error.message}');
    }
  }
}
