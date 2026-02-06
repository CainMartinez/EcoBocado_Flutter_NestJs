import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/orders_api_client.dart';
import '../../domain/entities/order.dart';
import '../../domain/dto/create_order_dto.dart';
import '../../../cart/domain/models/cart_state.dart';

/// Provider del cliente API
final ordersApiClientProvider = Provider<OrdersApiClient>((ref) {
  return OrdersApiClient();
});

/// Estado para las órdenes del usuario
class OrdersState {
  final List<Order> orders;
  final bool isLoading;
  final String? error;

  const OrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
  });

  OrdersState copyWith({
    List<Order>? orders,
    bool? isLoading,
    String? error,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier para manejar las órdenes
class OrdersNotifier extends Notifier<OrdersState> {
  late final OrdersApiClient _apiClient;

  @override
  OrdersState build() {
    _apiClient = ref.read(ordersApiClientProvider);
    return const OrdersState();
  }

  /// Carga las órdenes del usuario
  Future<void> loadOrders() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final orders = await _apiClient.getUserOrders();
      state = state.copyWith(
        orders: orders,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Crea una orden desde el carrito actual
  Future<Order?> createOrderFromCart(
    CartState cart, {
    String? deliveryType,
    int? pickupSlotId,
    String? pickupDate,
    String? pickupStartTime,
    String? pickupEndTime,
    int? venueId,
    int? userAddressId,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? stateProvince,
    String? postalCode,
    String? country,
    String? phone,
    String? deliveryNotes,
    String? estimatedDeliveryDate,
    String? estimatedDeliveryTime,
    String? notes,
    String? paymentIntentId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Convertir items del carrito a DTOs de orden
      final orderItems = cart.items.map((cartItem) {
        return CreateOrderItemDto(
          itemType: cartItem.item.type == 'product' ? 'product' : 'menu',
          itemId: cartItem.item.id,
          quantity: cartItem.quantity.toDouble(),
          unitPrice: cartItem.isRewardItem ? 0.0 : cartItem.item.price,
        );
      }).toList();

      final dto = CreateOrderDto(
        deliveryType: deliveryType ?? 'pickup',
        items: orderItems,
        pickupSlotId: pickupSlotId,
        pickupDate: pickupDate,
        pickupStartTime: pickupStartTime,
        pickupEndTime: pickupEndTime,
        venueId: venueId,
        userAddressId: userAddressId,
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        city: city,
        stateProvince: stateProvince,
        postalCode: postalCode,
        country: country,
        phone: phone,
        deliveryNotes: deliveryNotes,
        estimatedDeliveryDate: estimatedDeliveryDate,
        estimatedDeliveryTime: estimatedDeliveryTime,
        notes: notes,
        paymentIntentId: paymentIntentId,
      );

      final newOrder = await _apiClient.createOrder(dto);

      // Agregar la nueva orden al estado
      state = state.copyWith(
        orders: [newOrder, ...state.orders],
        isLoading: false,
      );

      return newOrder;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  /// Obtiene una orden específica
  Future<Order?> getOrderById(int orderId) async {
    try {
      return await _apiClient.getOrderById(orderId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }
}

/// Provider principal de órdenes
final ordersProvider = NotifierProvider<OrdersNotifier, OrdersState>(() {
  return OrdersNotifier();
});
