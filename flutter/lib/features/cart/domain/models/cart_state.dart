import '../../../shop/domain/entities/catalog_item.dart';

/// Item del carrito con cantidad
class CartItem {
  final CatalogItem item;
  final int quantity;
  final bool isRewardItem; // Indica si es un menú de rescate gratuito
  final int? redemptionId; // ID de la redención de fidelidad

  const CartItem({
    required this.item,
    required this.quantity,
    this.isRewardItem = false,
    this.redemptionId,
  });

  CartItem copyWith({
    CatalogItem? item,
    int? quantity,
    bool? isRewardItem,
    int? redemptionId,
  }) {
    return CartItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      isRewardItem: isRewardItem ?? this.isRewardItem,
      redemptionId: redemptionId ?? this.redemptionId,
    );
  }

  double get totalPrice => isRewardItem ? 0.0 : item.price * quantity;
}

/// Estado del carrito
class CartState {
  final List<CartItem> items;

  const CartState({this.items = const []});

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }
}
