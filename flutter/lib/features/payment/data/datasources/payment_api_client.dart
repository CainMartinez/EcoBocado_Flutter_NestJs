import 'package:dio/dio.dart';
import '../../../../core/utils/app_services.dart';

class PaymentApiClient {
  final Dio _dio;

  PaymentApiClient({Dio? dio}) : _dio = dio ?? AppServices.dio;

  /// Create a payment intent
  Future<Map<String, dynamic>> createPaymentIntent({
    required int amount,
    required String currency,
  }) async {
    try {
      final response = await _dio.post(
        '/payments/create-intent',
        data: {
          'amount': amount,
          'currency': currency,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get payment status
  Future<Map<String, dynamic>> getPaymentStatus(String paymentIntentId) async {
    try {
      final response = await _dio.get(
        '/payments/status/$paymentIntentId',
      );
      return response.data as Map<String, dynamic>;
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
