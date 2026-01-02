import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:eco_bocado/core/layout/app_shell.dart';
import 'package:eco_bocado/features/home/presentation/pages/home_page.dart';
import 'package:eco_bocado/features/profile/presentation/pages/profile_page.dart';
import 'package:eco_bocado/features/profile/presentation/pages/user_addresses_management_page.dart';
import 'package:eco_bocado/features/shop/presentation/pages/shop_page.dart';
import 'package:eco_bocado/features/admin/presentation/pages/dashboard_admin_page.dart';
import 'package:eco_bocado/features/admin/presentation/pages/products_admin_page.dart';
import 'package:eco_bocado/features/billing/presentation/pages/billing_admin_page.dart';
import 'package:eco_bocado/features/orders/presentation/screens/orders_screen.dart';
import 'package:eco_bocado/features/orders/presentation/pages/delivery_method_selection_page.dart';
import 'package:eco_bocado/features/orders/presentation/pages/pickup_selection_page.dart';
import 'package:eco_bocado/features/orders/presentation/pages/delivery_address_selection_page.dart';
import 'package:eco_bocado/features/orders/presentation/pages/delivery_time_selection_page.dart';
import 'package:eco_bocado/features/orders/presentation/pages/temporary_address_form_page.dart';

import 'package:eco_bocado/core/widgets/auth_gate.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Provider del router para evitar recrearlo en cada build
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(
          child: child,
        ),
        routes: [
          // Ruta de inicio para USUARIOS
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          
          // Rutas para USUARIOS
          GoRoute(
            path: '/menu',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ShopPage(),
            ),
          ),
          GoRoute(
            path: '/orders',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AuthGate(
                authPageKey: ValueKey('orders-auth'),
                child: OrdersScreen(),
              ),
            ),
          ),
          
          // Rutas para ADMIN
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AuthGate(
                authPageKey: ValueKey('dashboard-auth'),
                child: DashboardAdminPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/products',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AuthGate(
                authPageKey: ValueKey('products-auth'),
                child: ProductsAdminPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/billing',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AuthGate(
                authPageKey: ValueKey('billing-auth'),
                child: BillingAdminPage(),
              ),
            ),
          ),
          
          // Ruta de perfil (común)
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AuthGate(
                authPageKey: ValueKey('profile-auth'),
                child: ProfilePage(),
              ),
            ),
          ),
        ],
      ),
      
      // Rutas fuera del shell (pantallas completas)
      GoRoute(
        path: '/delivery-method-selection',
        builder: (context, state) => const DeliveryMethodSelectionPage(),
      ),
      GoRoute(
        path: '/pickup-selection',
        builder: (context, state) => const PickupSelectionPage(),
      ),
      GoRoute(
        path: '/delivery-address-selection',
        builder: (context, state) => const DeliveryAddressSelectionPage(),
      ),
      GoRoute(
        path: '/delivery-time-selection',
        builder: (context, state) => DeliveryTimeSelectionPage(
          addressData: state.extra as Map<String, dynamic>?,
        ),
      ),
      GoRoute(
        path: '/temporary-address-form',
        builder: (context, state) => const TemporaryAddressFormPage(),
      ),
      GoRoute(
        path: '/user-addresses-management',
        builder: (context, state) => const UserAddressesManagementPage(),
      ),
    ],
  );
});