import 'package:flutter/material.dart';
import 'package:eco_bocado/core/l10n/app_localizations.dart';
import '../../domain/entities/catalog_item.dart';

/// Card de producto/menú del catálogo
class ProductCard extends StatelessWidget {
  final CatalogItem item;
  final VoidCallback onTap;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.item,
    required this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            AspectRatio(
              aspectRatio: 16 / 9,
              child: item.images.isNotEmpty
                  ? Image.network(
                      item.images.first,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _buildPlaceholder(context),
                    )
                  : _buildPlaceholder(context),
            ),
            
            // Contenido con altura fija
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tipo y badges en fila con wrap
                    Wrap(
                      spacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (item.isMenu)
                          Chip(
                            label: Text(
                              AppLocalizations.of(context)!.menuBadge,
                              style: const TextStyle(fontSize: 9),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          ),
                        if (item.isVegan)
                          const Icon(Icons.eco, size: 14, color: Colors.green),
                      ],
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Nombre del producto
                    Text(
                      item.name(context),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const Spacer(),
                    
                    // Precio y botón añadir
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            '${item.price.toStringAsFixed(2)} ${item.currency}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (onAddToCart != null)
                          IconButton.filled(
                            onPressed: onAddToCart,
                            icon: const Icon(Icons.add_shopping_cart),
                            iconSize: 18,
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        item.isMenu ? Icons.restaurant_menu : Icons.fastfood,
        size: 48,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
