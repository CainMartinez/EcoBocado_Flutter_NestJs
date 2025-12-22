import 'package:dio/dio.dart';
import '../../../../core/utils/app_services.dart';

/// Cliente API para gestión de alérgenos del usuario
class UserAllergenApiClient {
  final Dio _dio;

  UserAllergenApiClient({Dio? dio}) : _dio = dio ?? AppServices.dio;

  /// GET /profile/allergens - Obtiene los alérgenos del usuario
  Future<List<String>> getUserAllergens() async {
    try {
      final response = await _dio.get('/profile/allergens');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((code) => code as String).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST /profile/allergens/:allergenCode - Agrega un alérgeno al perfil
  Future<void> addAllergen(String allergenCode) async {
    try {
      await _dio.post('/profile/allergens/$allergenCode');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE /profile/allergens/:allergenCode - Elimina un alérgeno del perfil
  Future<void> removeAllergen(String allergenCode) async {
    try {
      await _dio.delete('/profile/allergens/$allergenCode');
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
