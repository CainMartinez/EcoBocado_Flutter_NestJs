import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:eco_bocado/core/l10n/app_localizations.dart';
import 'package:eco_bocado/features/profile/presentation/providers/profile_provider.dart';
import 'package:eco_bocado/features/profile/presentation/pages/update_profile_page.dart';
import 'package:eco_bocado/features/profile/presentation/pages/change_password_page.dart';
import 'package:eco_bocado/features/profile/presentation/widgets/editable_profile_avatar.dart';
import 'package:eco_bocado/features/profile/presentation/widgets/profile_role_badge.dart';
import 'package:eco_bocado/features/profile/presentation/widgets/profile_info_row.dart';
import 'package:eco_bocado/features/profile/presentation/widgets/user_allergens_section.dart';
import 'package:eco_bocado/features/auth/presentation/providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myProfile),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(profileProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) => RefreshIndicator(
          onRefresh: () async {
            await ref.read(profileProvider.notifier).refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Avatar grande con botón de edición
                Center(
                  child: EditableProfileAvatar(
                    avatarUrl: profile.avatarUrl,
                    name: profile.name,
                    radius: 60,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Nombre
                Center(
                  child: Text(
                    profile.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 4),
                
                // Email
                Center(
                  child: Text(
                    profile.email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Badge de tipo de usuario
                Center(
                  child: ProfileRoleBadge(isAdmin: profile.isAdmin),
                ),
                const SizedBox(height: 24),

                // 🌟 SECCIÓN DESTACADA DE ALÉRGENOS - Solo para usuarios (no admins)
                if (!profile.isAdmin) ...[  
                  const UserAllergensSection(),
                  const SizedBox(height: 24),
                ],

                // Sección de información
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.personalInfo,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const Divider(),
                        const SizedBox(height: 8),
                        
                        // Teléfono
                        ProfileInfoRow(
                          icon: Icons.phone,
                          label: l10n.phone,
                          value: profile.phone ?? l10n.notProvided,
                        ),
                        const SizedBox(height: 12),
                        
                        // Dirección línea 1
                        ProfileInfoRow(
                          icon: Icons.home,
                          label: l10n.address,
                          value: profile.addressLine1 ?? l10n.notProvided,
                        ),
                        if (profile.addressLine2 != null && profile.addressLine2!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Text(
                              profile.addressLine2!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        
                        // Ciudad
                        ProfileInfoRow(
                          icon: Icons.location_city,
                          label: l10n.city,
                          value: profile.city ?? l10n.notProvided,
                        ),
                        const SizedBox(height: 12),
                        
                        // Código Postal
                        ProfileInfoRow(
                          icon: Icons.pin_drop,
                          label: l10n.postalCode,
                          value: profile.postalCode ?? l10n.notProvided,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Botón de editar perfil
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const UpdateProfilePage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: Text(l10n.editProfile),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(height: 8),

                // Botón de gestionar direcciones (solo para usuarios normales)
                if (profile.isUser) ...[
                  OutlinedButton.icon(
                    onPressed: () {
                      context.push('/user-addresses-management');
                    },
                    icon: const Icon(Icons.location_on),
                    label: const Text('Mis direcciones de entrega'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                // Botón de cambiar contraseña (solo para usuarios normales)
                if (profile.isUser) ...[
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ChangePasswordPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.lock),
                    label: Text(l10n.changePassword),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                // Botón de cerrar sesión
                ElevatedButton.icon(
                  onPressed: () => _handleLogout(context, ref),
                  icon: const Icon(Icons.logout),
                  label: Text(l10n.logout),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                l10n.errorLoadingProfile,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(profileProvider.notifier).refresh();
                },
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context)!;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.logoutConfirmTitle),
        content: Text(l10n.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(authProvider.notifier).logout();
        
        if (context.mounted) {
          context.go('/home');
        }
      } catch (e) {
        if (context.mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.errorLoggingOut}: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
