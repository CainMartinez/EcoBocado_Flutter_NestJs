import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eco_bocado/app/app.dart';
import 'package:eco_bocado/features/settings/presentation/providers/preferences_provider.dart';
import 'package:eco_bocado/core/services/push_notification_service.dart';
import 'core/utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar Stripe solo en plataformas móviles (no web)
  if (!kIsWeb) {
    Stripe.publishableKey = publicKeyStripe;
    
    // Inicializar notificaciones push
    final pushService = PushNotificationService();
    await pushService.initialize();
    await pushService.requestPermissions();
  }

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const EcoBocadoApp(),
    ),
  );
}