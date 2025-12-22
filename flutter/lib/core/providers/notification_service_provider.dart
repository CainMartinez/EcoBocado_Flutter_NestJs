import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ultramessage_api_client.dart';
import '../services/push_notification_service.dart';
import '../config/env.dart';
import '../../features/settings/presentation/providers/preferences_provider.dart';

/// Provider del cliente de UltraMessage
/// 
/// Las credenciales se configuran en: lib/core/config/env.dart
final ultraMessageProvider = Provider<UltraMessageApiClient>((ref) {
  return UltraMessageApiClient(
    instanceId: Env.ultraMessageInstanceId,
    token: Env.ultraMessageToken,
  );
});

/// Provider del servicio de notificaciones push
final pushNotificationProvider = Provider<PushNotificationService>((ref) {
  return PushNotificationService();
});

/// Servicio de notificaciones que maneja WhatsApp y Push
class NotificationService {
  final UltraMessageApiClient _whatsappClient;
  final PushNotificationService _pushService;
  final Ref _ref;

  NotificationService({
    required UltraMessageApiClient whatsappClient,
    required PushNotificationService pushService,
    required Ref ref,
  })  : _whatsappClient = whatsappClient,
        _pushService = pushService,
        _ref = ref;

  /// Envía notificación de confirmación de pedido
  /// Respeta las preferencias del usuario
  Future<void> sendOrderConfirmation({
    required String phoneNumber,
    required String orderNumber,
    required String estimatedDate,
    required String estimatedTime,
    required String deliveryType,
    required double totalAmount,
  }) async {
    
    final preferencesAsync = _ref.read(preferencesProvider);
    final preferences = preferencesAsync.value;

    if (preferences == null) {
      return;
    }

    // Enviar WhatsApp si está habilitado
    if (preferences.whatsappNotifications == true) {
      try {
        await _whatsappClient.sendOrderConfirmation(
          phoneNumber: phoneNumber,
          orderNumber: orderNumber,
          estimatedDate: estimatedDate,
          estimatedTime: estimatedTime,
          deliveryType: deliveryType,
          totalAmount: totalAmount,
        );
      } catch (e, stackTrace) {
        debugPrintStack(stackTrace: stackTrace);
      }
    } else {
      // WhatsApp deshabilitado
    }

    // Enviar notificación push si está habilitada
    if (preferences.appNotifications == true) {
      try {
        await _pushService.sendOrderConfirmation(
          orderNumber: orderNumber,
          estimatedDate: estimatedDate,
          estimatedTime: estimatedTime,
          deliveryType: deliveryType,
          totalAmount: totalAmount,
        );
      } catch (e, stackTrace) {
        debugPrintStack(stackTrace: stackTrace);
      }
    } else {
      // Push notifications deshabilitadas
    }
  }

  /// Envía actualización de estado de pedido
  Future<void> sendOrderStatusUpdate({
    required String phoneNumber,
    required String orderNumber,
    required String status,
  }) async {
    final preferencesAsync = _ref.read(preferencesProvider);
    final preferences = preferencesAsync.value;

    if (preferences == null) return;

    // Push notification
    if (preferences.appNotifications == true) {
      try {
        await _pushService.sendOrderStatusUpdate(
          orderNumber: orderNumber,
          status: status,
        );
      } catch (e) {
        // No interrumpir el flujo si falla la notificación push
      }
    }

    // WhatsApp (solo para estados importantes)
    if (preferences.whatsappNotifications == true && 
        ['ready', 'on_the_way', 'delivered'].contains(status.toLowerCase())) {
      try {
        String message = '';
        switch (status.toLowerCase()) {
          case 'ready':
            message = 'Tu pedido *$orderNumber* está listo para recoger!';
            break;
          case 'on_the_way':
            message = 'Tu pedido *$orderNumber* está en camino! Pronto llegaremos.';
            break;
          case 'delivered':
            message = '¡Tu pedido *$orderNumber* ha sido entregado! Esperamos que lo disfrutes.';
            break;
        }
        
        if (message.isNotEmpty) {
          await _whatsappClient.sendMessage(
            to: phoneNumber,
            body: message,
          );
        }
      } catch (e) {
        // No interrumpir el flujo si falla WhatsApp
      }
    }
  }
}

/// Provider del servicio de notificaciones
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(
    whatsappClient: ref.watch(ultraMessageProvider),
    pushService: ref.watch(pushNotificationProvider),
    ref: ref,
  );
});
