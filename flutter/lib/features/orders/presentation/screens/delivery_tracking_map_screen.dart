import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../providers/delivery_location_provider.dart';
import '../../domain/entities/delivery_location.dart';

/// Pantalla del mapa de tracking del delivery en tiempo real
class DeliveryTrackingMapScreen extends ConsumerStatefulWidget {
  const DeliveryTrackingMapScreen({
    super.key,
    required this.orderId,
    this.initialLatitude,
    this.initialLongitude,
  });

  final int orderId;
  final double? initialLatitude;
  final double? initialLongitude;

  @override
  ConsumerState<DeliveryTrackingMapScreen> createState() =>
      _DeliveryTrackingMapScreenState();
}

class _DeliveryTrackingMapScreenState
    extends ConsumerState<DeliveryTrackingMapScreen> {
  late MapController _mapController;
  LatLng? _lastCenter;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  void _updateMapCenter(double latitude, double longitude) {
    final newCenter = LatLng(latitude, longitude);
    // Solo actualizar si la ubicación ha cambiado significativamente
    if (_lastCenter == null || 
        (_lastCenter!.latitude - newCenter.latitude).abs() > 0.0001 ||
        (_lastCenter!.longitude - newCenter.longitude).abs() > 0.0001) {
      _lastCenter = newCenter;
      // Animar hacia la nueva posición
      _mapController.move(newCenter, _mapController.camera.zoom);
    }
  }

  void _centerOnDelivery(double latitude, double longitude) {
    // Centrar y hacer zoom en la ubicación del repartidor
    _mapController.move(LatLng(latitude, longitude), 16.0);
    _lastCenter = LatLng(latitude, longitude);
  }

  @override
  Widget build(BuildContext context) {
    final locationAsync = ref.watch(deliveryLocationPollingProvider(widget.orderId));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return locationAsync.when(
      data: (location) {
        // Si hay ubicación del backend, usarla. Si no, usar Madrid como centro por defecto
        final latitude = location?.latitude ?? 40.4168;
        final longitude = location?.longitude ?? -3.7038;

        // Actualizar centro del mapa si hay ubicación real
        if (location != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateMapCenter(location.latitude, location.longitude);
          });
        }

        return _buildScaffold(
          context,
          theme,
          colorScheme,
          latitude,
          longitude,
          location,
          false,
          null,
        );
      },
      loading: () {
        final latitude = widget.initialLatitude ?? 40.4168;
        final longitude = widget.initialLongitude ?? -3.7038;
        
        return _buildScaffold(
          context,
          theme,
          colorScheme,
          latitude,
          longitude,
          null,
          true,
          null,
        );
      },
      error: (error, stack) {
        final latitude = widget.initialLatitude ?? 40.4168;
        final longitude = widget.initialLongitude ?? -3.7038;
        
        return _buildScaffold(
          context,
          theme,
          colorScheme,
          latitude,
          longitude,
          null,
          false,
          error.toString(),
        );
      },
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    double latitude,
    double longitude,
    DeliveryLocation? location,
    bool isLoading,
    String? error,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seguimiento del Pedido #${widget.orderId}'),
        actions: [
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          // Mapa de OpenStreetMap
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(latitude, longitude),
              initialZoom: 16.0,
              minZoom: 5.0,
              maxZoom: 19.0,
            ),
            children: [
              // Capa de tiles de OpenStreetMap
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.ecobocado.app',
              ),

              // Marcador de la ubicación del repartidor
              if (location != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(location.latitude, location.longitude),
                      width: 80,
                      height: 90,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha:0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.delivery_dining,
                              color: colorScheme.onPrimary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha:0.1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Text(
                              'Repartidor',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Botón flotante para centrar en la ubicación del repartidor
          if (location != null)
            Positioned(
              right: 16,
              bottom: 180, // Encima del panel de información
              child: FloatingActionButton(
                onPressed: () => _centerOnDelivery(location.latitude, location.longitude),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                tooltip: 'Centrar en repartidor',
                child: const Icon(Icons.my_location),
              ),
            ),

          // Panel de información en la parte inferior
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Ubicación del Repartidor',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      error,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 8),
                    Text(
                      'El mapa se actualiza automáticamente cada 30 segundos.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
