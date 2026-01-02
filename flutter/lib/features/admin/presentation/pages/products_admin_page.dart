import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eco_bocado/core/l10n/app_localizations.dart';
import 'package:eco_bocado/features/admin/presentation/providers/product_admin_provider.dart';
import 'package:eco_bocado/features/admin/presentation/widgets/product_admin_card.dart';
import 'package:eco_bocado/features/admin/presentation/widgets/product_form_dialog.dart';
import 'package:eco_bocado/features/shop/domain/entities/category.dart';
import 'package:eco_bocado/features/shop/presentation/providers/catalog_provider.dart';

class ProductsAdminPage extends ConsumerStatefulWidget {
  const ProductsAdminPage({super.key});

  @override
  ConsumerState<ProductsAdminPage> createState() => _ProductsAdminPageState();
}

class _ProductsAdminPageState extends ConsumerState<ProductsAdminPage> {
  String? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Cargar productos y categorías al iniciar
    Future.microtask(() {
      ref.read(productAdminProvider.notifier).loadProducts();
      // Precargar categorías para que estén disponibles al abrir el filtro
      ref.read(categoriesProvider);
    });
    
    // Listener para búsqueda dinámica
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productAdminProvider);
    final notifier = ref.read(productAdminProvider.notifier);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.productManagement),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showCategoryFilter(),
            tooltip: l10n.filterByCategory,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => notifier.loadProducts(),
            tooltip: l10n.reload,
          ),
        ],
      ),
      body: Column(
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchProducts,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
            ),
          ),
          // Contenido principal
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.errorMessage != null
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: cs.error),
                      const SizedBox(height: 16),
                      Text(
                        l10n.errorLoadingProducts,
                        style: tt.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.errorMessage!,
                        style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: Text(l10n.retry),
                        onPressed: () => notifier.loadProducts(),
                      ),
                    ],
                  ),
                )
              : _filteredProducts(state.products).isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined, size: 64, color: cs.onSurfaceVariant),
                          const SizedBox(height: 16),
                          Text(
                            _selectedCategory != null ? 'No hay productos en esta categoría' : l10n.noProducts,
                            style: tt.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _selectedCategory != null ? 'Prueba con otra categoría' : l10n.createFirstProduct,
                            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                          ),
                          if (_selectedCategory != null) ...[
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() => _selectedCategory = null);
                              },
                              child: Text(l10n.clearFilters),
                            ),
                          ],
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        // Indicador de categoría activa
                        if (_selectedCategory != null)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            color: cs.primaryContainer,
                            child: Row(
                              children: [
                                Icon(Icons.filter_list, color: cs.onPrimaryContainer, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${l10n.category}: ${_getCategoryName(_selectedCategory!)}',
                                    style: tt.bodyMedium?.copyWith(color: cs.onPrimaryContainer),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: cs.onPrimaryContainer, size: 20),
                                  onPressed: () {
                                    setState(() => _selectedCategory = null);
                                  },
                                  tooltip: l10n.clearFilters,
                                ),
                              ],
                            ),
                          ),
                        // Contador de resultados
                        if (_searchQuery.isNotEmpty || _selectedCategory != null)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            color: cs.surfaceContainerHighest,
                            child: Text(
                              '${_filteredProducts(state.products).length} ${_filteredProducts(state.products).length == 1 ? 'producto encontrado' : 'productos encontrados'}',
                              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                            ),
                          ),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () => notifier.loadProducts(),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _filteredProducts(state.products).length,
                              itemBuilder: (context, index) {
                                final product = _filteredProducts(state.products)[index];
                                return ProductAdminCard(
                                  product: product,
                                  key: ValueKey(product.id),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => const ProductFormDialog(),
          );
          // Recargar productos después de cerrar el modal
          if (mounted) {
            ref.read(productAdminProvider.notifier).loadProducts();
          }
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.newProduct),
      ),
    );
  }

  /// Filtra los productos según la categoría seleccionada y búsqueda de texto
  List<dynamic> _filteredProducts(List<dynamic> products) {
    var filtered = products;
    
    // Filtrar por categoría
    if (_selectedCategory != null) {
      filtered = filtered.where((p) => p.categoryCode == _selectedCategory).toList();
    }
    
    // Filtrar por búsqueda de texto (solo en el idioma actual)
    if (_searchQuery.isNotEmpty) {
      final locale = Localizations.localeOf(context);
      final isEnglish = locale.languageCode == 'en';
      
      filtered = filtered.where((p) {
        final name = isEnglish 
            ? (p.nameEn ?? '').toLowerCase()
            : (p.nameEs ?? '').toLowerCase();
        return name.contains(_searchQuery);
      }).toList();
    }
    
    return filtered;
  }

  /// Muestra el selector de categoría
  void _showCategoryFilter() {
    final categoriesAsync = ref.read(categoriesProvider);
    
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
                        },
                      ),
                      ...categories.map((category) => ListTile(
                            title: Text(category.name(context)),
                            trailing: _selectedCategory == category.code ? const Icon(Icons.check) : null,
                            selected: _selectedCategory == category.code,
                            onTap: () {
                              setState(() => _selectedCategory = category.code);
                              Navigator.pop(context);
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
          const SnackBar(content: Text('Cargando categorías...')),
        );
      },
      error: (error, stack) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      },
    );
  }

  /// Obtiene el nombre de la categoría por su código
  String _getCategoryName(String code) {
    final categoriesAsync = ref.read(categoriesProvider);
    return categoriesAsync.when(
      data: (categories) {
        final category = categories.firstWhere(
          (c) => c.code == code,
          orElse: () => Category(id: 0, code: code, nameEs: code, nameEn: code),
        );
        return category.name(context);
      },
      loading: () => code,
      error: (error, stackTrace) => code,
    );
  }
}
