import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eco_bocado/core/l10n/app_localizations.dart';
import '../../domain/entities/catalog_filters.dart';
import '../../domain/entities/catalog_state.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/allergen.dart';
import '../providers/catalog_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/product_detail_modal.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../../core/widgets/app_filter_chip.dart';
import '../../../profile/presentation/providers/user_allergens_provider.dart';

class ShopPage extends ConsumerStatefulWidget {
  const ShopPage({super.key});

  @override
  ConsumerState<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<ShopPage> {
  final ScrollController _scrollController = ScrollController();
  
  // Filtros
  String? _selectedCategory;
  bool? _isVegan;
  final List<String> _excludedAllergens = [];
  String _sortBy = 'createdAt';
  String _sortOrder = 'desc';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Carga inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserAllergensAndCatalog();
    });
  }

  /// Carga los alérgenos del usuario y luego el catálogo
  Future<void> _loadUserAllergensAndCatalog() async {
    // Intentar cargar los alérgenos del usuario
    final userAllergensAsync = ref.read(userAllergensProvider);
    
    if (userAllergensAsync.hasValue) {
      final userAllergens = userAllergensAsync.value ?? [];
      setState(() {
        // Poblar _excludedAllergens con los alérgenos del usuario
        _excludedAllergens.clear();
        _excludedAllergens.addAll(userAllergens);
      });
    }
    
    // Cargar el catálogo con los filtros iniciales
    _loadCatalog();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Cerca del final, cargar más
      ref.read(catalogProvider.notifier).loadMore();
    }
  }

  void _loadCatalog() {
    final filters = CatalogFilters(
      categoryCode: _selectedCategory,
      isVegan: _isVegan,
      excludeAllergens: _excludedAllergens.isEmpty ? null : _excludedAllergens,
      sortBy: _sortBy,
      sortOrder: _sortOrder,
      limit: 20,
    );
    ref.read(catalogProvider.notifier).loadCatalog(filters);
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = null;
      _isVegan = null;
      _excludedAllergens.clear();
    });
    _loadCatalog();
  }

  bool get _hasActiveFilters =>
      _selectedCategory != null ||
      _isVegan != null ||
      _excludedAllergens.isNotEmpty;



  void _showCategorySelector(AsyncValue<List<Category>> categoriesAsync) {
    categoriesAsync.when(
      data: (categories) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.67,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) => Column(
              children: [
                ListTile(
                  title: Text(AppLocalizations.of(context)!.filterByCategory),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.allCategories),
                        trailing: _selectedCategory == null ? const Icon(Icons.check) : null,
                        selected: _selectedCategory == null,
                        onTap: () {
                          setState(() => _selectedCategory = null);
                          Navigator.pop(context);
                          _loadCatalog();
                        },
                      ),
                      ...categories.map((category) => ListTile(
                            title: Text(category.name(context)),
                            trailing: _selectedCategory == category.code ? const Icon(Icons.check) : null,
                            selected: _selectedCategory == category.code,
                            onTap: () {
                              setState(() => _selectedCategory = category.code);
                              Navigator.pop(context);
                              _loadCatalog();
                            },
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
      loading: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.loadingProducts)),
        );
      },
      error: (error, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.errorLoadingProducts}: $error')),
        );
      },
    );
  }

  void _showAllergenSelector(AsyncValue<List<Allergen>> allergensAsync) {
    // Obtener los alérgenos del perfil del usuario
    final userAllergensAsync = ref.read(userAllergensProvider);
    final userAllergens = userAllergensAsync.value ?? [];
    
    allergensAsync.when(
      data: (allergens) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => StatefulBuilder(
            builder: (context, setModalState) => DraggableScrollableSheet(
              initialChildSize: 1,
              minChildSize: 0.4,
              maxChildSize: 1,
              expand: false,
              builder: (context, scrollController) => Column(
                children: [
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.filterByAllergens),
                    subtitle: Text(_excludedAllergens.isEmpty 
                      ? AppLocalizations.of(context)!.noAllergensSelected 
                      : AppLocalizations.of(context)!.allergensSelectedCount(_excludedAllergens.length)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_excludedAllergens.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              setState(() => _excludedAllergens.clear());
                              setModalState(() {});
                              _loadCatalog();
                            },
                            child: Text(AppLocalizations.of(context)!.clearFilters),
                          ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  // Mensaje informativo sobre protección automática
                  if (userAllergens.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.shield, color: Colors.orange.shade700, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Los alérgenos con 🛡️ están en tu perfil de protección y se aplican automáticamente',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: allergens.length,
                      itemBuilder: (context, index) {
                        final allergen = allergens[index];
                        final isSelected = _excludedAllergens.contains(allergen.code);
                        final isFromProfile = userAllergens.contains(allergen.code);
                        
                        return CheckboxListTile(
                          title: Row(
                            children: [
                              Expanded(child: Text(allergen.displayName(context))),
                              if (isFromProfile)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.shield, size: 14, color: Colors.orange.shade700),
                                      const SizedBox(width: 2),
                                      Text(
                                        'Perfil',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.orange.shade900,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          value: isSelected,
                          activeColor: isFromProfile ? Colors.orange : null,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                _excludedAllergens.add(allergen.code);
                              } else {
                                _excludedAllergens.remove(allergen.code);
                              }
                            });
                            setModalState(() {});
                            _loadCatalog();
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
      loading: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.loadingProducts)),
        );
      },
      error: (error, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.errorLoadingProducts}: $error')),
        );
      },
    );
  }

  void _showSortOptions() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(l10n.sortBy),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Divider(),
              _buildSortOption(l10n.sortByNewest, 'createdAt', 'desc'),
              _buildSortOption(l10n.sortByOldest, 'createdAt', 'asc'),
              _buildSortOption(l10n.sortByPriceAsc, 'price', 'asc'),
              _buildSortOption(l10n.sortByPriceDesc, 'price', 'desc'),
              _buildSortOption(l10n.sortByNameAsc, 'name', 'asc'),
              _buildSortOption(l10n.sortByNameDesc, 'name', 'asc'),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, String sortBy, String sortOrder) {
    final isSelected = _sortBy == sortBy && _sortOrder == sortOrder;
    return ListTile(
      title: Text(label),
      trailing: isSelected ? const Icon(Icons.check) : null,
      selected: isSelected,
      onTap: () {
        setState(() {
          _sortBy = sortBy;
          _sortOrder = sortOrder;
        });
        Navigator.pop(context);
        _loadCatalog();
      },
    );
  }

  String _getCategoryLabel(AsyncValue<List<Category>> categoriesAsync) {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedCategory == null) return l10n.allCategories;
    
    return categoriesAsync.when(
      data: (categories) {
        final category = categories.firstWhere(
          (c) => c.code == _selectedCategory,
          orElse: () => Category(id: 0, code: '', nameEs: l10n.allCategories, nameEn: l10n.allCategories),
        );
        return category.name(context);
      },
      loading: () => l10n.loadingProducts,
      error: (_, _) => l10n.errorLoadingProducts,
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalogState = ref.watch(catalogProvider);
    final cartItemCount = ref.watch(cartItemCountProvider);
    
    // Precargar categorías y alérgenos
    final categoriesAsync = ref.watch(categoriesProvider);
    final allergensAsync = ref.watch(allergensProvider);

    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.shopPageTitle),
        actions: [
          // Botón de ordenar
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortOptions,
          ),
          // Carrito con badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartPage(),
                    ),
                  );
                },
              ),
              if (cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$cartItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Filtros en fila
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Selector de categoría
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showCategorySelector(categoriesAsync),
                    icon: const Icon(Icons.category),
                    label: Text(
                      _getCategoryLabel(categoriesAsync),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Selector de alérgenos
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showAllergenSelector(allergensAsync),
                    icon: const Icon(Icons.warning_amber),
                    label: Text(
                      _excludedAllergens.isEmpty 
                        ? l10n.filterByAllergens 
                        : '${l10n.filterByAllergens} (${_excludedAllergens.length})',
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: _excludedAllergens.isNotEmpty
                      ? OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.orange, width: 2),
                          foregroundColor: Colors.orange,
                        )
                      : null,
                  ),
                ),
              ],
            ),
          ),
          
          // Filtro vegano y botón limpiar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                AppFilterChip(
                  label: l10n.veganOnly,
                  selected: _isVegan == true,
                  onTap: () {
                    setState(() {
                      _isVegan = _isVegan == true ? null : true;
                    });
                    _loadCatalog();
                  },
                  icon: Icons.eco,
                ),
                const Spacer(),
                if (_hasActiveFilters)
                  TextButton.icon(
                    onPressed: _clearFilters,
                    icon: const Icon(Icons.clear_all, size: 18),
                    label: Text(l10n.clearFilters),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
              ],
            ),
          ),
          
          const Divider(),
          
          // Banner de protección automática
          Consumer(
            builder: (context, ref, _) {
              final userAllergensAsync = ref.watch(userAllergensProvider);
              return userAllergensAsync.when(
                data: (userAllergens) {
                  if (userAllergens.isEmpty) return const SizedBox.shrink();
                  
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade50, Colors.orange.shade100],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.shield_outlined, color: Colors.orange.shade700, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '🛡️ Protección Automática Activa',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Se están filtrando ${userAllergens.length} alérgeno${userAllergens.length > 1 ? 's' : ''} de tu perfil',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              );
            },
          ),
          
          // Lista de productos
          Expanded(
            child: _buildProductList(catalogState),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(CatalogState catalogState) {
    final l10n = AppLocalizations.of(context)!;
    
    if (catalogState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('${l10n.errorLoadingProducts}: ${catalogState.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCatalog,
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    if (catalogState.items.isEmpty && !catalogState.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag_outlined, size: 48),
            const SizedBox(height: 16),
            Text(l10n.noProductsFound),
            const SizedBox(height: 8),
            Text(
              l10n.tryAdjustingFilters,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: catalogState.items.length + (catalogState.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= catalogState.items.length) {
          // Loading indicator al final
          return const Center(child: CircularProgressIndicator());
        }

        final item = catalogState.items[index];
        return ProductCard(
          item: item,
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => ProductDetailModal(item: item),
            );
          },
          onAddToCart: () {
            ref.read(cartProvider.notifier).addItem(item);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.addedToCart(item.name(context))),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        );
      },
    );
  }
}
