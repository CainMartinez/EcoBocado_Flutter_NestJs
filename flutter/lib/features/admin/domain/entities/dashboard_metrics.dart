class DashboardMetrics {
  final int totalOrders;
  final double totalRevenue;
  final int totalProducts;
  final int totalUsers;

  const DashboardMetrics({
    required this.totalOrders,
    required this.totalRevenue,
    required this.totalProducts,
    required this.totalUsers,
  });

  factory DashboardMetrics.fromJson(Map<String, dynamic> json) {
    return DashboardMetrics(
      totalOrders: json['totalOrders'] as int,
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalProducts: json['totalProducts'] as int,
      totalUsers: json['totalUsers'] as int,
    );
  }
}
