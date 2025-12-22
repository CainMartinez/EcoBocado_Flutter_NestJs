import 'dart:async';
import 'package:flutter/material.dart';
import 'package:eco_bocado/core/l10n/app_localizations.dart';
import '../../domain/entities/catalog_item.dart';

/// Modal con detalles del producto/menú
class ProductDetailModal extends StatefulWidget {
  final CatalogItem item;

  const ProductDetailModal({
    super.key,
    required this.item,
  });

  @override
  State<ProductDetailModal> createState() => _ProductDetailModalState();
}

class _ProductDetailModalState extends State<ProductDetailModal> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    if (widget.item.images.length > 1) {
      _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (_pageController.hasClients) {
          final nextPage = (_currentImageIndex + 1) % widget.item.images.length;
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = widget.item.images.isNotEmpty;
    
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle para arrastrar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Carrusel de imágenes
                      if (hasImages) ...[
                        SizedBox(
                          height: 300,
                          child: Stack(
                            children: [
                              PageView.builder(
                                controller: _pageController,
                                onPageChanged: (index) {
                                  setState(() => _currentImageIndex = index);
                                },
                                itemCount: widget.item.images.length,
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    widget.item.images[index],
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Container(
                                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                      child: Icon(
                                        widget.item.isMenu ? Icons.restaurant_menu : Icons.fastfood,
                                        size: 64,
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // Indicadores de página
                              if (widget.item.images.length > 1)
                                Positioned(
                                  bottom: 16,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      widget.item.images.length,
                                      (index) => Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 4),
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _currentImageIndex == index
                                              ? Theme.of(context).colorScheme.primary
                                              : Colors.white.withValues(alpha: 0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ] else
                        Container(
                          height: 250,
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: Icon(
                            widget.item.isMenu ? Icons.restaurant_menu : Icons.fastfood,
                            size: 64,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tipo y badges
                            Row(
                              children: [
                                if (widget.item.isMenu)
                                  Chip(
                                    label: Text(AppLocalizations.of(context)!.menuBadge),
                                    avatar: const Icon(Icons.restaurant_menu, size: 18),
                                  ),
                                if (widget.item.isVegan) ...[
                                  const SizedBox(width: 8),
                                  Chip(
                                    label: Text(AppLocalizations.of(context)!.veganOnly),
                                    avatar: const Icon(
                                      Icons.eco, 
                                      size: 18,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Nombre
                            Text(
                              widget.item.name(context),
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Categoría
                            Text(
                              widget.item.category.name(context).toUpperCase(),
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Precio
                            Text(
                              '${widget.item.price.toStringAsFixed(2)} ${widget.item.currency}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Descripción
                            Text(
                              AppLocalizations.of(context)!.description,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.item.description(context),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Alérgenos
                            if (widget.item.allergens.isNotEmpty) ...[
                              Text(
                                AppLocalizations.of(context)!.allergens,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: widget.item.allergens.map((allergen) {
                                  final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
                                  final bool isContains = allergen.contains;
                                  final bool isMayContain = allergen.mayContain;

                                  // Determinar el color según la prioridad: contains > mayContain
                                  final bool useRedStyle = isContains;
                                  final bool useOrangeStyle = !isContains && isMayContain;
                                  
                                  return Chip(
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(allergen.displayName(context)),
                                        if (isContains || isMayContain) ...[
                                          const SizedBox(width: 4),
                                          Text(
                                            isContains ? '✓' : '~',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: isDarkMode
                                                  ? (useRedStyle ? Colors.red.shade300 : Colors.orange.shade300)
                                                  : (useRedStyle ? Colors.red.shade800 : Colors.orange.shade800),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    avatar: Icon(
                                      useRedStyle ? Icons.warning : (useOrangeStyle ? Icons.info_outline : Icons.info),
                                      size: 18,
                                      color: isDarkMode
                                          ? (useRedStyle ? Colors.red.shade300 : (useOrangeStyle ? Colors.orange.shade300 : Colors.grey.shade400))
                                          : (useRedStyle ? Colors.red.shade800 : (useOrangeStyle ? Colors.orange.shade800 : Colors.grey.shade600)),
                                    ),
                                    backgroundColor: isDarkMode
                                        ? (useRedStyle ? Colors.red.shade900.withValues(alpha: 0.3) : (useOrangeStyle ? Colors.orange.shade900.withValues(alpha: 0.3) : Colors.grey.shade800.withValues(alpha: 0.3)))
                                        : (useRedStyle ? Colors.red.shade100 : (useOrangeStyle ? Colors.orange.shade100 : Colors.grey.shade100)),
                                    labelStyle: TextStyle(
                                      color: isDarkMode
                                          ? (useRedStyle ? Colors.red.shade200 : (useOrangeStyle ? Colors.orange.shade200 : Colors.grey.shade300))
                                          : (useRedStyle ? Colors.red.shade900 : (useOrangeStyle ? Colors.orange.shade900 : Colors.grey.shade700)),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '✓ ${AppLocalizations.of(context)!.contains} • ~ ${AppLocalizations.of(context)!.mayContain}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                            
                            // Composición del menú (solo para menús)
                            if (widget.item.isMenu && widget.item.menuComposition != null) ...[
                              Text(
                                AppLocalizations.of(context)!.menuComposition,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              _buildMenuCompositionItem(
                                context,
                                AppLocalizations.of(context)!.drink,
                                Icons.local_drink,
                                widget.item.menuComposition!.drinkId,
                              ),
                              _buildMenuCompositionItem(
                                context,
                                AppLocalizations.of(context)!.sideDish,
                                Icons.restaurant,
                                widget.item.menuComposition!.starterId,
                              ),
                              _buildMenuCompositionItem(
                                context,
                                AppLocalizations.of(context)!.mainCourse,
                                Icons.dinner_dining,
                                widget.item.menuComposition!.mainId,
                              ),
                              _buildMenuCompositionItem(
                                context,
                                AppLocalizations.of(context)!.dessert,
                                Icons.cake,
                                widget.item.menuComposition!.dessertId,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuCompositionItem(
    BuildContext context,
    String label,
    IconData icon,
    int productId,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
