import 'package:dio/dio.dart';
import '../../domain/entities/catalog_filters.dart';
import '../../domain/entities/paginated_catalog.dart';
import '../../domain/entities/allergen.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/rescue_menu.dart';
import '../../../../core/utils/app_services.dart';

/// Cliente API para el módulo Shop
class ShopApiClient {
  final Dio _dio;

  ShopApiClient({Dio? dio}) : _dio = dio ?? AppServices.dio;

  /// Obtiene el catálogo con filtros
  Future<PaginatedCatalog> getCatalog(CatalogFilters filters) async {
    try {
      final queryParams = filters.toQueryParams();
      
      final response = await _dio.get(
        '/products',
        queryParameters: queryParams,
      );

      return PaginatedCatalog.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Obtiene todos los alérgenos disponibles
  Future<List<Allergen>> getAllergens() async {
    try {
      final response = await _dio.get('/products/allergens');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => Allergen.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Obtiene todas las categorías disponibles
  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get('/products/categories');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => Category.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Obtiene todos los menús de rescate activos
  Future<List<RescueMenu>> getRescueMenus() async {
    try {
      final response = await _dio.get('/products/rescue-menus');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => RescueMenu.fromJson(json as Map<String, dynamic>)).toList();
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
