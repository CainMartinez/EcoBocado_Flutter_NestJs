import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eco_bocado/catalog/catalog_page.dart';
import 'package:eco_bocado/core/widgets/primary_cta_bar.dart';
import 'package:eco_bocado/features/settings/presentation/providers/preferences_provider.dart';
import 'package:eco_bocado/features/settings/presentation/widgets/settings_section_title.dart';
import 'package:eco_bocado/features/settings/presentation/widgets/settings_switch_tile.dart';
import 'package:eco_bocado/core/l10n/app_localizations.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferencesAsync = ref.watch(preferencesProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.preferences)),
      body: preferencesAsync.when(
        data: (preferences) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SettingsSectionTitle(text: l10n.notificationsSection),
            SettingsSwitchTile(
              label: l10n.appNotifications,
              value: preferences.appNotifications ?? false,
              onChanged: (value) {
                ref.read(preferencesProvider.notifier).updateAppNotifications(value);
              },
              icon: Icons.notifications,
            ),
            SettingsSwitchTile(
              label: l10n.whatsappNotifications,
              value: preferences.whatsappNotifications ?? false,
              onChanged: (value) {
                ref.read(preferencesProvider.notifier).updateWhatsappNotifications(value);
              },
              icon: Icons.chat,
            ),
            const SizedBox(height: 24),
            SettingsSectionTitle(text: l10n.appearanceSection),   
            SettingsSwitchTile(
              label: l10n.darkMode,
              value: preferences.darkMode ?? false,
              onChanged: (value) {
                ref.read(preferencesProvider.notifier).updateDarkMode(value);
              },
            ),
            const SizedBox(height: 24),
            SettingsSectionTitle(text: l10n.languageSection),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.language),
              subtitle: Text(
                preferences.language == 'en' ? l10n.languageEnglish : l10n.languageSpanish,
              ),
              trailing: DropdownButton<String>(
                value: preferences.language ?? 'es',
                items: [
                  DropdownMenuItem(value: 'es', child: Text(l10n.languageSpanish)),
                  DropdownMenuItem(value: 'en', child: Text(l10n.languageEnglish)),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref.read(preferencesProvider.notifier).updateLanguage(value);
                  }
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(l10n.errorLoadingPreferences(error.toString())),
        ),
      ),
      bottomNavigationBar: PrimaryCtaBar(
        label: l10n.viewCatalog,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CatalogPage()),
          );
        },
      ),
    );
  }
}