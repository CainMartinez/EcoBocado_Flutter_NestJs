import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eco_bocado/features/shop/presentation/providers/rescue_menu_provider.dart';
import 'package:eco_bocado/features/shop/domain/entities/catalog_item.dart';
import 'package:eco_bocado/features/cart/presentation/providers/cart_provider.dart';
import 'package:eco_bocado/features/cart/presentation/pages/cart_page.dart';
import '../providers/loyalty_provider.dart';

class RedeemRewardScreen extends ConsumerStatefulWidget {
  const RedeemRewardScreen({super.key});

  @override
  ConsumerState<RedeemRewardScreen> createState() => _RedeemRewardScreenState();
}

class _RedeemRewardScreenState extends ConsumerState<RedeemRewardScreen> {
  int? selectedMenuId;
  bool isRedeeming = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final menusAsync = ref.watch(rescueMenusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Canjear Recompensa'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            child: Column(
              children: [
                Icon(
                  Icons.celebration,
                  size: 48,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  '¡Felicidades!',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Selecciona el menú que deseas canjear',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: menusAsync.when(
              data: (menus) {
                if (menus.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 64,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay menús disponibles',
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: menus.length,
                  itemBuilder: (context, index) {
                    final menu = menus[index];
                    final isSelected = selectedMenuId == menu.id;
                    final locale = Localizations.localeOf(context);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: isSelected ? 4 : 1,
                      color: isSelected
                          ? colorScheme.primaryContainer
                          : null,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedMenuId = menu.id;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: colorScheme.primary,
                                  size: 32,
                                )
                              else
                                Icon(
                                  Icons.radio_button_unchecked,
                                  color: colorScheme.onSurfaceVariant,
                                  size: 32,
                                ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      menu.name(locale.languageCode),
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? colorScheme.onPrimaryContainer
                                            : null,
                                      ),
                                    ),
                                    if (menu.description(locale.languageCode).isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        menu.description(locale.languageCode),
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: isSelected
                                              ? colorScheme.onPrimaryContainer.withValues(alpha: 0.8)
                                              : colorScheme.onSurfaceVariant,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                    const SizedBox(height: 12),
                                    // Mostrar productos incluidos
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 4,
                                      children: [
                                        if (menu.drink != null)
                                          _buildProductChip(
                                            context,
                                            Icons.local_drink,
                                            menu.drink!.name(locale.languageCode),
                                            isSelected,
                                          ),
                                        if (menu.starter != null)
                                          _buildProductChip(
                                            context,
                                            Icons.restaurant,
                                            menu.starter!.name(locale.languageCode),
                                            isSelected,
                                          ),
                                        if (menu.main != null)
                                          _buildProductChip(
                                            context,
                                            Icons.lunch_dining,
                                            menu.main!.name(locale.languageCode),
                                            isSelected,
                                          ),
                                        if (menu.dessert != null)
                                          _buildProductChip(
                                            context,
                                            Icons.cake,
                                            menu.dessert!.name(locale.languageCode),
                                            isSelected,
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? colorScheme.primary
                                            : colorScheme.secondaryContainer,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Precio: ${menu.price.toStringAsFixed(2)} EUR',
                                        style: theme.textTheme.labelMedium?.copyWith(
                                          color: isSelected
                                              ? Colors.white
                                              : colorScheme.onSecondaryContainer,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: colorScheme.error),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar menús',
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: selectedMenuId == null || isRedeeming
                ? null
                : () async {
                    setState(() {
                      isRedeeming = true;
                    });

                    try {
                      // Obtener el menú seleccionado
                      final menusAsync = ref.read(rescueMenusProvider);
                      final selectedMenu = menusAsync.value?.firstWhere(
                        (menu) => menu.id == selectedMenuId,
                      );

                      if (selectedMenu == null) {
                        throw Exception('Menú no encontrado');
                      }

                      // Canjear la recompensa
                      final redemption = await ref.read(redeemRewardProvider(selectedMenuId!).future);
                      
                      if (context.mounted) {
                        // Convertir RescueMenu a CatalogItem para el carrito
                        // Recopilar todas las imágenes de los productos del menú
                        final menuImages = <String>[];
                        if (selectedMenu.drink?.images.isNotEmpty ?? false) {
                          menuImages.addAll(selectedMenu.drink!.images);
                        }
                        if (selectedMenu.starter?.images.isNotEmpty ?? false) {
                          menuImages.addAll(selectedMenu.starter!.images);
                        }
                        if (selectedMenu.main?.images.isNotEmpty ?? false) {
                          menuImages.addAll(selectedMenu.main!.images);
                        }
                        if (selectedMenu.dessert?.images.isNotEmpty ?? false) {
                          menuImages.addAll(selectedMenu.dessert!.images);
                        }
                        
                        final catalogItem = CatalogItem(
                          id: selectedMenu.id,
                          uuid: selectedMenu.uuid ?? '',
                          type: 'rescue_menu',
                          nameEs: selectedMenu.nameEs,
                          nameEn: selectedMenu.nameEn,
                          descriptionEs: selectedMenu.descriptionEs,
                          descriptionEn: selectedMenu.descriptionEn,
                          price: selectedMenu.price,
                          currency: selectedMenu.currency,
                          isVegan: selectedMenu.isVegan,
                          category: const CategoryInfo(
                            code: 'REWARD',
                            nameEs: 'Menú Premio',
                            nameEn: 'Reward Menu',
                          ),
                          allergens: const [],
                          images: menuImages,
                          menuComposition: null,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        );

                        // Agregar al carrito como menú de rescate gratuito
                        ref.read(cartProvider.notifier).addRewardItem(
                          catalogItem,
                          redemption.id,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('¡Menú gratuito agregado al carrito!'),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        
                        ref.invalidate(loyaltyAccountProvider);
                        
                        // Navegar al carrito
                        Navigator.pop(context); // Cerrar pantalla de redención
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartPage(),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    } finally {
                      if (mounted) {
                        setState(() {
                          isRedeeming = false;
                        });
                      }
                    }
                  },
            icon: isRedeeming
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.check),
            label: Text(
              isRedeeming ? 'Canjeando...' : 'Confirmar Canje',
            ),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductChip(
    BuildContext context,
    IconData icon,
    String label,
    bool isSelected,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.primary.withValues(alpha: 0.2)
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isSelected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
