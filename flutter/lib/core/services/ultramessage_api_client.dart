import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Cliente para la API de UltraMessage (WhatsApp)
class UltraMessageApiClient {
  final Dio _dio;
  final String instanceId;
  final String token;

  UltraMessageApiClient({
    required this.instanceId,
    required this.token,
    Dio? dio,
  }) : _dio = dio ?? Dio(BaseOptions(
          baseUrl: 'https://api.ultramsg.com/$instanceId',
          headers: {
            'Content-Type': 'application/json',
          },
        ));

  /// Envía un mensaje de WhatsApp
  /// 
  /// [to] - Número de teléfono con código de país (ej: +34612345678)
  /// [body] - Texto del mensaje
  Future<void> sendMessage({
    required String to,
    required String body,
  }) async {
    try {
      
      final response = await _dio.post(
        '/messages/chat',
        data: {
          'token': token,
          'to': to,
          'body': body,
        },
      );
      debugPrintStack(label: response.toString());
    } on DioException catch (e) {
      throw Exception('Error enviando WhatsApp: ${e.message}');
    }
  }

  /// Envía un mensaje de WhatsApp con imagen
  Future<void> sendImageMessage({
    required String to,
    required String imageUrl,
    String? caption,
  }) async {
    try {
      await _dio.post(
        '/messages/image',
        data: {
          'token': token,
          'to': to,
          'image': imageUrl,
          'caption': caption ?? '',
        },
      );
    } on DioException catch (e) {
      throw Exception('Error enviando imagen WhatsApp: ${e.message}');
    }
  }

  /// Envía confirmación de pedido
  Future<void> sendOrderConfirmation({
    required String phoneNumber,
    required String orderNumber,
    required String estimatedDate,
    required String estimatedTime,
    required String deliveryType,
    required double totalAmount,
  }) async {
    final message = '''
🎉 *¡Pedido Confirmado!*

📦 Número de pedido: *$orderNumber*

${deliveryType == 'delivery' ? '🚚 Entrega estimada:' : '🏪 Recogida:'}
📅 Día: *$estimatedDate*
⏰ Hora: *$estimatedTime*

💰 Total: *${totalAmount.toStringAsFixed(2)} EUR*

Gracias por confiar en EcoBocado 🌱

''';

    await sendMessage(
      to: phoneNumber,
      body: message,
    );
  }
}
