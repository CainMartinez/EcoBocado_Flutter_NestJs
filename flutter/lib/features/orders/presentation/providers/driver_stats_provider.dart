import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/orders_api_client.dart';
import '../../domain/entities/driver_stats.dart';

/// Provider para obtener estadísticas de velocidad de repartidores
final driverStatsProvider = FutureProvider<DriverStatsResponse>((ref) async {
  final apiClient = OrdersApiClient();
  return await apiClient.getDriverStats();
});
