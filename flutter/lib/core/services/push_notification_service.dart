import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Servicio de notificaciones push locales
class PushNotificationService {
  static final PushNotificationService _instance = PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Inicializa el servicio de notificaciones
  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  /// Maneja cuando el usuario toca una notificación
  void _onNotificationTapped(NotificationResponse response) {
    // Aquí puedes navegar a la pantalla de pedidos
  }

  /// Solicita permisos de notificación (iOS)
  Future<bool> requestPermissions() async {
    final result = await _notifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    return result ?? true;
  }

  /// Envía notificación de confirmación de pedido
  Future<void> sendOrderConfirmation({
    required String orderNumber,
    required String estimatedDate,
    required String estimatedTime,
    required String deliveryType,
    required double totalAmount,
  }) async {
    
    if (!_initialized) {
      await initialize();
    }

    // Configuración Android con máxima visibilidad
    const androidDetails = AndroidNotificationDetails(
      'order_confirmations',
      'Confirmaciones de Pedido',
      channelDescription: 'Notificaciones cuando se confirma un pedido',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      styleInformation: BigTextStyleInformation(''),
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final title = '🎉 ¡Pedido Confirmado!';
    final body = deliveryType == 'delivery'
        ? '📦 Pedido $orderNumber\n🚚 Día: $estimatedDate\n⏰ Hora: $estimatedTime\n💰 Total: ${totalAmount.toStringAsFixed(2)} EUR'
        : '📦 Pedido $orderNumber\n🏪 Día: $estimatedDate\n⏰ Hora: $estimatedTime\n💰 Total: ${totalAmount.toStringAsFixed(2)} EUR';
    
    await _notifications.show(
      orderNumber.hashCode, // ID único basado en el número de pedido
      title,
      body,
      details,
      payload: 'order:$orderNumber',
    );
  }

  /// Envía notificación de actualización de estado de pedido
  Future<void> sendOrderStatusUpdate({
    required String orderNumber,
    required String status,
  }) async {
    if (!_initialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      'order_updates',
      'Actualizaciones de Pedido',
      channelDescription: 'Notificaciones de cambios de estado del pedido',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    String statusText;
    String emoji;
    
    switch (status.toLowerCase()) {
      case 'preparing':
        emoji = '👨‍🍳';
        statusText = 'Tu pedido se está preparando';
        break;
      case 'ready':
        emoji = '✅';
        statusText = '¡Tu pedido está listo!';
        break;
      case 'on_the_way':
        emoji = '🚚';
        statusText = 'Tu pedido está en camino';
        break;
      case 'delivered':
        emoji = '🎉';
        statusText = '¡Pedido entregado!';
        break;
      default:
        emoji = '📦';
        statusText = 'Actualización de pedido';
    }

    await _notifications.show(
      orderNumber.hashCode + 1000, // ID diferente para actualizaciones
      '$emoji Pedido $orderNumber',
      statusText,
      details,
      payload: 'order:$orderNumber',
    );
  }

  /// Cancela todas las notificaciones
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
