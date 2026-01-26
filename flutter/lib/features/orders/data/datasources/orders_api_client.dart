import 'package:dio/dio.dart';
import '../../../../core/utils/app_services.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/delivery_location.dart';
import '../../domain/entities/driver_stats.dart';
import '../../domain/dto/create_order_dto.dart';

/// Cliente API para el módulo de Orders
class OrdersApiClient {
  final Dio _dio;

  OrdersApiClient({Dio? dio}) : _dio = dio ?? AppServices.dio;

  /// Crea una nueva orden
  Future<Order> createOrder(CreateOrderDto dto) async {
    try {
      final response = await _dio.post(
        '/orders',
        data: dto.toJson(),
      );

      return Order.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Obtiene todas las órdenes del usuario autenticado
  Future<List<Order>> getUserOrders() async {
    try {
      final response = await _dio.get('/orders');
      
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => Order.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Obtiene una orden específica por ID
  Future<Order> getOrderById(int orderId) async {
    try {
      final response = await _dio.get('/orders/$orderId');
      
      return Order.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Obtiene la ubicación del repartidor de un pedido específico
  Future<DeliveryLocation?> getDeliveryLocation(int orderId) async {
    try {
      final response = await _dio.get('/orders/$orderId/location');
      
      if (response.data == null) {
        return null;
      }
      
      return DeliveryLocation.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw _handleDioError(e);
    }
  }

  /// Obtiene estadísticas de velocidad de repartidores (top 3)
  Future<DriverStatsResponse> getDriverStats() async {
    try {
      final response = await _dio.get('/orders/stats/drivers');
      return DriverStatsResponse.fromJson(response.data as Map<String, dynamic>);
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
