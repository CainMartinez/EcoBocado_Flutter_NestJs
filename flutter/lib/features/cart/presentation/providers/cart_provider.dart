import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/cart_state.dart';
import '../../../shop/domain/entities/catalog_item.dart';

/// Notificador del carrito
class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() => const CartState();

  /// Añade un item al carrito o incrementa su cantidad
  void addItem(CatalogItem item) {
    // Buscar item existente, ignorando items de premio
    final existingIndex = state.items.indexWhere(
      (cartItem) => cartItem.item.id == item.id && !cartItem.isRewardItem,
    );

    if (existingIndex >= 0) {
      // Incrementar cantidad
      final updatedItems = List<CartItem>.from(state.items);
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + 1,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      // Añadir nuevo item
      state = state.copyWith(
        items: [...state.items, CartItem(item: item, quantity: 1)],
      );
    }
  }

  /// Añade un menú de rescate gratuito (premio de fidelidad)
  void addRewardItem(CatalogItem item, int redemptionId) {
    // Los menús de rescate siempre son únicos y no se pueden incrementar
    final existingIndex = state.items.indexWhere(
      (cartItem) => cartItem.isRewardItem && cartItem.item.id == item.id,
    );

    if (existingIndex < 0) {
      // Añadir menú de rescate gratuito
      state = state.copyWith(
        items: [
          ...state.items,
          CartItem(
            item: item,
            quantity: 1,
            isRewardItem: true,
            redemptionId: redemptionId,
          ),
        ],
      );
    }
  }

  /// Elimina una unidad del item o lo quita del carrito si quantity = 1
  /// No afecta a items de premio
  void removeItem(int itemId) {
    final existingIndex = state.items.indexWhere(
      (cartItem) => cartItem.item.id == itemId && !cartItem.isRewardItem,
    );

    if (existingIndex >= 0) {
      final currentQuantity = state.items[existingIndex].quantity;
      
      if (currentQuantity > 1) {
        // Decrementar cantidad
        final updatedItems = List<CartItem>.from(state.items);
        updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
          quantity: currentQuantity - 1,
        );
        state = state.copyWith(items: updatedItems);
      } else {
        // Eliminar del carrito
        final updatedItems = List<CartItem>.from(state.items)..removeAt(existingIndex);
        state = state.copyWith(items: updatedItems);
      }
    }
  }

  /// Elimina completamente un item del carrito
  /// No afecta a items de premio
  void deleteItem(int itemId) {
    final updatedItems = state.items.where(
      (cartItem) => cartItem.item.id != itemId || cartItem.isRewardItem,
    ).toList();
    state = state.copyWith(items: updatedItems);
  }

  /// Limpia el carrito, manteniendo items de premio
  void clear() {
    final rewardItems = state.items.where((item) => item.isRewardItem).toList();
    state = CartState(items: rewardItems);
  }

  /// Limpia TODO el carrito, incluyendo premios (solo para uso después de confirmar pedido)
  void clearAll() {
    state = const CartState();
  }
}

/// Provider del carrito
final cartProvider = NotifierProvider<CartNotifier, CartState>(() {
  return CartNotifier();
});

/// Provider solo del contador de items (para el badge)
final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.totalItems;
});
