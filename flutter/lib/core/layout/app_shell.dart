import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eco_bocado/core/l10n/app_localizations.dart';
import 'package:eco_bocado/core/layout/widgets/app_navigation_bar.dart';
import 'package:eco_bocado/features/settings/presentation/pages/settings_page.dart';
import 'package:eco_bocado/features/auth/presentation/providers/auth_provider.dart';
import 'package:eco_bocado/features/profile/presentation/providers/profile_provider.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  void _openSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const SettingsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final authAsync = ref.watch(authProvider);
    final profileAsync = ref.watch(profileProvider);
        
    final auth = authAsync.when(
      data: (value) => value,
      loading: () => null,
      error: (e, st) => null,
    );

    final isLogged = auth?.isAuthenticated ?? false;
    final isAdmin = auth?.isAdmin ?? false;
    final displayName = auth?.displayName;
    
    // Obtener avatarUrl del profileProvider para que se actualice automáticamente
    final avatarUrl = profileAsync.whenOrNull(
      data: (profile) => profile.avatarUrl,
    );

    final l10n = AppLocalizations.of(context)!;

    // Definir rutas y títulos según el rol
    final List<String> paths;
    final List<String> titles;
    
    if (isAdmin) {
      // Rutas para ADMIN: Dashboard, Productos, Facturación, Perfil
      paths = ['/dashboard', '/products', '/billing', '/profile'];
      titles = [l10n.dashboard, l10n.products, l10n.billing, l10n.profile];
    } else {
      // Rutas para USUARIO: Inicio, Menú, Pedidos, Perfil
      paths = ['/home', '/menu', '/orders', '/profile'];
      titles = [l10n.home, l10n.menu, l10n.orders, l10n.profile];
    }

    // Obtener el índice actual basado en la ruta
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = paths.indexOf(location);
    final selectedIndex = currentIndex >= 0 ? currentIndex : 0;

    final currentTitle = titles[selectedIndex];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => context.go(isAdmin ? '/dashboard' : '/home'),
              child: Row(
                children: [
                  Image.asset('assets/images/logo.jpg', height: 72),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EcoBocado',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        currentTitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 1,
              height: 24,
              color: cs.outlineVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 16),
          ],
        ),
        actions: [
          if (isLogged && displayName != null) ...[
            GestureDetector(
              onTap: () => context.go('/profile'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${l10n.hello}, $displayName',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  // if (auth?.isAdmin == true) ...[
                  //   const SizedBox(width: 6),
                  //   Container(
                  //     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  //     decoration: BoxDecoration(
                  //       color: Colors.red.withValues(alpha: 0.1),
                  //       border: Border.all(color: Colors.red, width: 1),
                  //       borderRadius: BorderRadius.circular(4),
                  //     ),
                  //     child: const Text(
                  //       'ADMIN',
                  //       style: TextStyle(
                  //         fontSize: 10,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.red,
                  //       ),
                  //     ),
                  //   ),
                  // ],
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
          GestureDetector(
            onTap: () => context.go('/profile'),
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: cs.secondaryContainer,
                backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                    ? NetworkImage(avatarUrl)
                    : null,
                child: (avatarUrl == null || avatarUrl.isEmpty)
                    ? const Icon(Icons.person, size: 18)
                    : null,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l10n.preferences,
            onPressed: () => _openSettings(context),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: AppNavigationBar(
        isAdmin: isAdmin,
        selectedIndex: selectedIndex,
        paths: paths,
      ),
    );
  }
}