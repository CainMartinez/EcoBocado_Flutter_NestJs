import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/orders_provider.dart';
import '../widgets/order_list_item.dart';
import '../widgets/orders_empty_state.dart';
import '../widgets/orders_error_view.dart';

/// Pantalla que muestra el historial de órdenes del usuario
class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar órdenes al iniciar
    Future.microtask(() => ref.read(ordersProvider.notifier).loadOrders());
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Pedidos'),
        actions: [
          if (!ordersState.isLoading && ordersState.orders.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.read(ordersProvider.notifier).loadOrders(),
              tooltip: 'Actualizar',
            ),
        ],
      ),
      body: _buildBody(ordersState),
    );
  }

  Widget _buildBody(OrdersState ordersState) {
    if (ordersState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (ordersState.error != null) {
      return OrdersErrorView(
        error: ordersState.error!,
        onRetry: () => ref.read(ordersProvider.notifier).loadOrders(),
      );
    }

    if (ordersState.orders.isEmpty) {
      return const OrdersEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(ordersProvider.notifier).loadOrders(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: ordersState.orders.length,
        itemBuilder: (context, index) {
          final order = ordersState.orders[index];
          return OrderListItem(order: order);
        },
      ),
    );
  }
}
