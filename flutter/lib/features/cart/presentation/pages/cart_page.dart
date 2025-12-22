import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter/material.dart' as material show Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/notification_service_provider.dart';
import '../../domain/models/cart_state.dart';
import '../providers/cart_provider.dart';
import '../../../orders/domain/entities/order.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../../../orders/presentation/screens/orders_screen.dart';
import '../../../payment/presentation/providers/payment_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myCart),
        actions: [
          if (cartState.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _showClearCartDialog(context),
              tooltip: l10n.clearCartTooltip,
            ),
        ],
      ),
      body: cartState.items.isEmpty
          ? _buildEmptyCart(context)
          : _buildCartContent(context, cartState),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.emptyCartTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.emptyCartMessage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.restaurant_menu),
            label: Text(AppLocalizations.of(context)!.viewMenu),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartState cartState) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: cartState.items.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final cartItem = cartState.items[index];
              return _buildCartItemCard(context, cartItem);
            },
          ),
        ),
        _buildCartSummary(context, cartState),
      ],
    );
  }

  Widget _buildCartItemCard(BuildContext context, CartItem cartItem) {
    return material.Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: cartItem.item.images.isNotEmpty
                  ? Image.network(
                      cartItem.item.images.first,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _buildPlaceholderImage(context, cartItem),
                    )
                  : _buildPlaceholderImage(context, cartItem),
            ),
            const SizedBox(width: 12),
            // Información del producto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.item.name(context),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cartItem.item.category.name(context),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${cartItem.item.price.toStringAsFixed(2)} ${cartItem.item.currency}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (cartItem.item.isVegan) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.eco,
                          size: 16,
                          color: Colors.green,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Controles de cantidad
            Column(
              children: [
                _buildQuantityControls(context, cartItem),
                const SizedBox(height: 8),
                Text(
                  '${cartItem.totalPrice.toStringAsFixed(2)} €',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(BuildContext context, CartItem cartItem) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        cartItem.item.isMenu ? Icons.restaurant_menu : Icons.fastfood,
        size: 32,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildQuantityControls(BuildContext context, CartItem cartItem) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              cartItem.quantity > 1 ? Icons.remove : Icons.delete_outline,
              size: 18,
            ),
            onPressed: () {
              ref.read(cartProvider.notifier).removeItem(cartItem.item.id);
            },
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            color: cartItem.quantity > 1
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.error,
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 32),
            alignment: Alignment.center,
            child: Text(
              '${cartItem.quantity}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 18),
            onPressed: () {
              ref.read(cartProvider.notifier).addItem(cartItem.item);
            },
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context, CartState cartState) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Resumen de precios
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.subtotal,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  '${cartState.totalPrice.toStringAsFixed(2)} €',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.totalItems,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                Text(
                  '${cartState.totalItems}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.total,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${cartState.totalPrice.toStringAsFixed(2)} €',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Botón confirmar pedido
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _handleConfirmOrder(context, cartState),
                icon: const Icon(Icons.shopping_bag_outlined),
                label: Text(AppLocalizations.of(context)!.confirmOrder),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleConfirmOrder(BuildContext context, CartState cartState) {
    final authState = ref.read(authProvider);
    
    authState.when(
      data: (auth) {
        if (!auth.isAuthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Debes iniciar sesión para realizar un pedido'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          // Navegar a la selección de método de entrega
          context.push('/delivery-method-selection').then((result) {
            if (result != null && result is Map<String, dynamic> && context.mounted) {
              _processPaymentAndOrder(context, cartState, result, auth.displayName);
            }
          });
        }
      },
      loading: () {},
      error: (_, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debes iniciar sesión para realizar un pedido'),
            backgroundColor: Colors.orange,
          ),
        );
      },
    );
  }

  void _showClearCartDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearCartDialogTitle),
        content: Text(l10n.clearCartDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clear();
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.clear),
          ),
        ],
      ),
    );
  }

  Future<void> _processPaymentAndOrder(
    BuildContext context,
    CartState cartState,
    Map<String, dynamic> deliveryData,
    String? userName,
  ) async {
    // Solo permitir pedidos en móvil (con pago)
    if (kIsWeb) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Los pedidos solo están disponibles en la aplicación móvil'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }
    
    try {
      // 1. Procesar pago con Stripe
      final paymentService = ref.read(paymentServiceProvider);
      final paymentIntentId = await paymentService.processPayment(
        amount: cartState.totalPrice,
        currency: 'eur',
        customerName: userName,
      );
      
      // Esperar a que el pago se confirme en el backend
      await Future.delayed(const Duration(seconds: 2));
      
      // Verificar que el pago está completado
      final paymentStatus = await paymentService.getPaymentStatus(paymentIntentId);
      if (paymentStatus['status'] != 'succeeded') {
        throw Exception('El pago no se completó correctamente');
      }

      // 2. Crear la orden con el pago confirmado y los datos de delivery
      final order = await ref.read(ordersProvider.notifier).createOrderFromCart(
        cartState,
        deliveryType: deliveryData['deliveryType'] as String?,
        
        // Pickup fields
        pickupSlotId: deliveryData['pickupSlotId'] as int?,
        pickupDate: deliveryData['pickupDate'] as String?,
        pickupStartTime: deliveryData['pickupStartTime'] as String?,
        pickupEndTime: deliveryData['pickupEndTime'] as String?,
        venueId: deliveryData['venueId'] as int?,
        
        // Delivery fields
        userAddressId: deliveryData['userAddressId'] as int?,
        addressLine1: deliveryData['addressLine1'] as String?,
        addressLine2: deliveryData['addressLine2'] as String?,
        city: deliveryData['city'] as String?,
        stateProvince: deliveryData['stateProvince'] as String?,
        postalCode: deliveryData['postalCode'] as String?,
        country: deliveryData['country'] as String?,
        phone: deliveryData['deliveryPhone'] as String?,
        deliveryNotes: deliveryData['deliveryNotes'] as String?,
        estimatedDeliveryDate: deliveryData['estimatedDeliveryDate'] as String?,
        estimatedDeliveryTime: deliveryData['estimatedDeliveryTime'] as String?,
        
        notes: deliveryData['notes'] as String?,
        paymentIntentId: paymentIntentId,
      );

      if (order != null) {
        // Enviar notificaciones
        _sendOrderNotifications(
          order: order,
          deliveryData: deliveryData,
          ref: ref,
        );

        // Limpiar carrito
        ref.read(cartProvider.notifier).clear();

        // Navegar a órdenes
        if (!context.mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const OrdersScreen(),
          ),
          (route) => route.isFirst,
        );

        // Mostrar mensaje de éxito
        Future.delayed(const Duration(milliseconds: 100), () {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Pedido y pago realizados con éxito!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );
          }
        });
      } else {
        // Si falla la creación, mostrar error
        if (!context.mounted) return;
        
        final error = ref.read(ordersProvider).error ?? 'Error al crear el pedido';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } on StripeException catch (e) {
      // Mostrar error
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error en el pago: ${e.error.localizedMessage ?? e.error.message}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } on UnsupportedError catch (e) {
      // Mostrar error
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Operación no soportada'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      // Mostrar error
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  /// Envía notificaciones de confirmación de pedido
  void _sendOrderNotifications({
    required Order order,
    required Map<String, dynamic> deliveryData,
    required WidgetRef ref,
  }) async {
    try {
      // Esperar a que el perfil esté cargado
      final profile = await ref.read(profileProvider.future);
      
      if (profile.phone == null || profile.phone!.isEmpty) {
        return;
      }

      // Formatear el tiempo estimado y la fecha
      final deliveryType = deliveryData['deliveryType'] as String? ?? 'pickup';
      String estimatedTime;
      String estimatedDate;
      
      if (deliveryType == 'pickup') {
        // Para pickup, usar la hora y fecha del slot seleccionado
        final startTime = deliveryData['pickupStartTime'] as String?;
        final endTime = deliveryData['pickupEndTime'] as String?;
        estimatedTime = startTime != null && endTime != null 
            ? '$startTime - $endTime'
            : 'Por confirmar';
        estimatedDate = deliveryData['pickupDate'] as String? ?? 'Por confirmar';
      } else {
        // Para delivery, usar la hora y fecha estimada
        final estimatedDeliveryTime = deliveryData['estimatedDeliveryTime'] as String?;
        estimatedTime = estimatedDeliveryTime ?? 'Por confirmar';
        estimatedDate = deliveryData['estimatedDeliveryDate'] as String? ?? 'Por confirmar';
      }

      // Formatear teléfono con código de país si no lo tiene
      String phoneNumber = profile.phone!;
      if (!phoneNumber.startsWith('+')) {
        phoneNumber = '+34$phoneNumber'; // Agregar código de España por defecto
      }

      // Enviar notificaciones
      final notificationService = ref.read(notificationServiceProvider);
      
      await notificationService.sendOrderConfirmation(
        phoneNumber: phoneNumber,
        orderNumber: order.id.toString(),
        estimatedDate: estimatedDate,
        estimatedTime: estimatedTime,
        deliveryType: deliveryType,
        totalAmount: order.total,
      );
      
    } catch (e, stackTrace) {
      // Manejar errores silenciosamente
      debugPrint('Error enviando notificaciones de pedido: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
