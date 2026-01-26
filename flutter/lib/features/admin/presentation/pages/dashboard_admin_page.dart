import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eco_bocado/core/l10n/app_localizations.dart';
import 'package:eco_bocado/features/admin/presentation/providers/dashboard_provider.dart';
import 'package:eco_bocado/features/orders/presentation/providers/driver_stats_provider.dart';
import 'package:eco_bocado/features/orders/presentation/screens/driver_stats_screen.dart';
import 'package:intl/intl.dart';

class DashboardAdminPage extends ConsumerStatefulWidget {
  const DashboardAdminPage({super.key});

  @override
  ConsumerState<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends ConsumerState<DashboardAdminPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    
    final metricsAsync = ref.watch(dashboardMetricsProvider);
    final recentOrdersAsync = ref.watch(recentOrdersProvider);
    final driverStatsAsync = ref.watch(driverStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(dashboardMetricsProvider);
              ref.invalidate(recentOrdersProvider);
              ref.invalidate(driverStatsProvider);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardMetricsProvider);
          ref.invalidate(recentOrdersProvider);
          ref.invalidate(driverStatsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sección de estadísticas principales
              Text(
                l10n.overview,
                style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              // Grid de métricas principales
              metricsAsync.when(
                data: (metrics) => GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    _buildMetricCard(
                      context,
                      icon: Icons.shopping_cart,
                      title: l10n.totalOrders,
                      value: metrics.totalOrders.toString(),
                      color: cs.primary,
                      iconColor: cs.onPrimary,
                    ),
                    _buildMetricCard(
                      context,
                      icon: Icons.attach_money,
                      title: l10n.revenue,
                      value: '${metrics.totalRevenue.toStringAsFixed(2)} €',
                      color: Colors.green,
                      iconColor: Colors.white,
                    ),
                    _buildMetricCard(
                      context,
                      icon: Icons.inventory_2,
                      title: l10n.products,
                      value: metrics.totalProducts.toString(),
                      color: Colors.orange,
                      iconColor: Colors.white,
                    ),
                    _buildMetricCard(
                      context,
                      icon: Icons.people,
                      title: l10n.users,
                      value: metrics.totalUsers.toString(),
                      color: Colors.blue,
                      iconColor: Colors.white,
                    ),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Error: $error', style: TextStyle(color: cs.error)),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Ranking de repartidores
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '🏆 Top Repartidores',
                    style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DriverStatsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Ver todo'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              driverStatsAsync.when(
                data: (stats) => stats.topDrivers.isEmpty
                    ? Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Icon(Icons.emoji_events_outlined, size: 64, color: cs.onSurfaceVariant),
                              const SizedBox(height: 16),
                              Text('Aún no hay estadísticas', style: tt.bodyLarge),
                              const SizedBox(height: 8),
                              Text(
                                'Los repartidores aparecerán cuando completen pedidos',
                                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Card(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: stats.topDrivers.length > 3 ? 3 : stats.topDrivers.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final driver = stats.topDrivers[index];
                            final isFirst = index == 0;
                            final isSecond = index == 1;
                            
                            String trophy;
                            Color trophyColor;
                            if (isFirst) {
                              trophy = '🥇';
                              trophyColor = const Color(0xFFFFD700);
                            } else if (isSecond) {
                              trophy = '🥈';
                              trophyColor = const Color(0xFFC0C0C0);
                            } else {
                              trophy = '🥉';
                              trophyColor = const Color(0xFFCD7F32);
                            }
                            
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: trophyColor,
                                child: Text(
                                  trophy,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                              title: Text(driver.driverName),
                              subtitle: Text('${driver.completedOrders} pedidos completados'),
                              trailing: Text(
                                driver.formattedTime,
                                style: tt.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: cs.primary,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                loading: () => const Card(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                error: (error, stack) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('Error: $error', style: TextStyle(color: cs.error)),
                    ),
                  ),
              ),
              
              const SizedBox(height: 24),
              
              // Pedidos recientes
              Text(
                l10n.recentOrders,
                style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              recentOrdersAsync.when(
                data: (orders) => orders.isEmpty
                    ? Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Icon(Icons.receipt_long, size: 64, color: cs.onSurfaceVariant),
                              const SizedBox(height: 16),
                              Text(l10n.noRecentOrders, style: tt.bodyLarge),
                              const SizedBox(height: 8),
                              Text(
                                l10n.ordersWillAppearHere,
                                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Card(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orders.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _getStatusColor(order.status),
                                child: Icon(
                                  _getOrderTypeIcon(order.orderType),
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              title: Text(order.customerName),
                              subtitle: Text(
                                '${_getStatusLabel(order.status, l10n)} • ${dateFormat.format(order.createdAt)}',
                              ),
                              trailing: Text(
                                '${order.totalAmount.toStringAsFixed(2)} €',
                                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        ),
                      ),
                loading: () => const Card(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                error: (error, stack) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('Error: $error', style: TextStyle(color: cs.error)),
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color iconColor,
  }) {
    final tt = Theme.of(context).textTheme;
    
    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withValues(alpha: 0.7)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: tt.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, color: iconColor, size: 28),
              ],
            ),
            Text(
              value,
              style: tt.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.blue;
      case 'prepared':
        return Colors.orange;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getOrderTypeIcon(String type) {
    return type == 'delivery' ? Icons.delivery_dining : Icons.shopping_bag;
  }

  String _getStatusLabel(String status, AppLocalizations l10n) {
    switch (status) {
      case 'confirmed':
        return 'Confirmado';
      case 'prepared':
        return 'Preparado';
      case 'delivered':
        return 'Entregado';
      case 'cancelled':
        return 'Cancelado';
      default:
        return status;
    }
  }
}
