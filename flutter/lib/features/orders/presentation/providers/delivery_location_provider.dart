import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/orders_api_client.dart';
import '../../domain/entities/delivery_location.dart';

/// Estado del tracking de ubicación
class DeliveryLocationState {
  final DeliveryLocation? location;
  final bool isLoading;
  final String? error;

  const DeliveryLocationState({
    this.location,
    this.isLoading = false,
    this.error,
  });

  DeliveryLocationState copyWith({
    DeliveryLocation? location,
    bool? isLoading,
    String? error,
  }) {
    return DeliveryLocationState(
      location: location ?? this.location,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Provider para obtener la ubicación de un pedido específico (carga única)
final deliveryLocationProvider = FutureProvider.family<DeliveryLocation?, int>((ref, orderId) async {
  final apiClient = OrdersApiClient();
  return await apiClient.getDeliveryLocation(orderId);
});

/// Provider para polling automático cada 30 segundos con carga inicial inmediata
final deliveryLocationPollingProvider = StreamProvider.family<DeliveryLocation?, int>((ref, orderId) {
  final apiClient = OrdersApiClient();
  
  // Función para obtener la ubicación
  Future<DeliveryLocation?> fetchLocation() async {
    try {
      return await apiClient.getDeliveryLocation(orderId);
    } catch (e) {
      return null;
    }
  }
  
  // Stream que emite inmediatamente y luego cada 30 segundos
  return Stream.multi((controller) async {
    // Emitir valor inicial inmediatamente
    final initialLocation = await fetchLocation();
    controller.add(initialLocation);
    
    // Luego emitir cada 30 segundos
    final timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      final location = await fetchLocation();
      controller.add(location);
    });
    
    // Cleanup cuando se cierre el stream
    controller.onCancel = () {
      timer.cancel();
    };
  });
});
