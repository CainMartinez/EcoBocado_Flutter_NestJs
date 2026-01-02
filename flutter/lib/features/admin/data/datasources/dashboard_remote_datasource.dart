import 'package:eco_bocado/core/utils/app_services.dart';

class DashboardRemoteDataSource {
  Future<Map<String, dynamic>> getDashboardMetrics() async {
    final response = await AppServices.dio.get('/admin/dashboard/metrics');
    return response.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> getRecentOrders({int limit = 10}) async {
    final response = await AppServices.dio.get(
      '/admin/dashboard/recent-orders',
      queryParameters: {'limit': limit},
    );
    return response.data as List<dynamic>;
  }

  Future<List<dynamic>> getTopProducts({int limit = 10}) async {
    final response = await AppServices.dio.get(
      '/admin/dashboard/top-products',
      queryParameters: {'limit': limit},
    );
    return response.data as List<dynamic>;
  }
}
