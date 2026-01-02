import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eco_bocado/features/admin/data/datasources/dashboard_remote_datasource.dart';
import 'package:eco_bocado/features/admin/domain/entities/dashboard_metrics.dart';
import 'package:eco_bocado/features/admin/domain/entities/recent_order.dart';
import 'package:eco_bocado/features/admin/domain/entities/top_product.dart';

final dashboardDataSourceProvider = Provider<DashboardRemoteDataSource>((ref) {
  return DashboardRemoteDataSource();
});

final dashboardMetricsProvider = FutureProvider<DashboardMetrics>((ref) async {
  final dataSource = ref.watch(dashboardDataSourceProvider);
  final data = await dataSource.getDashboardMetrics();
  return DashboardMetrics.fromJson(data);
});

final recentOrdersProvider = FutureProvider<List<RecentOrder>>((ref) async {
  final dataSource = ref.watch(dashboardDataSourceProvider);
  final data = await dataSource.getRecentOrders(limit: 10);
  return data.map((json) => RecentOrder.fromJson(json)).toList();
});

final topProductsProvider = FutureProvider<List<TopProduct>>((ref) async {
  final dataSource = ref.watch(dashboardDataSourceProvider);
  final data = await dataSource.getTopProducts(limit: 10);
  return data.map((json) => TopProduct.fromJson(json)).toList();
});
