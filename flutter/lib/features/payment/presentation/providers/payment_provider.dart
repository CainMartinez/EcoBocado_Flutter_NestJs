import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../data/datasources/payment_api_client.dart';

final paymentApiClientProvider = Provider<PaymentApiClient>((ref) {
  return PaymentApiClient();
});

final paymentServiceProvider = Provider<PaymentService>((ref) {
  final paymentApiClient = ref.watch(paymentApiClientProvider);
  return PaymentService(paymentApiClient);
});

class PaymentService {
  final PaymentApiClient _paymentApiClient;

  PaymentService(this._paymentApiClient);

  /// Create payment intent and return client secret
  Future<String> createPaymentIntent({
    required double amount,
    String currency = 'eur',
  }) async {
    // Convert amount to cents
    final int amountInCents = (amount * 100).round();

    final response = await _paymentApiClient.createPaymentIntent(
      amount: amountInCents,
      currency: currency,
    );

    return response['clientSecret'] as String;
  }

  /// Process payment with Stripe
  Future<String> processPayment({
    required double amount,
    String currency = 'eur',
    String? customerName,
  }) async {
    // En web, Stripe no está soportado de la misma manera
    if (kIsWeb) {
      throw UnsupportedError(
        'Los pagos con Stripe no están disponibles en web. '
        'Por favor, usa la aplicación móvil para completar el pago.',
      );
    }

    try {
      // 1. Create payment intent
      final clientSecret = await createPaymentIntent(
        amount: amount,
        currency: currency,
      );

      // 2. Present payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'EcoBocado',
          paymentIntentClientSecret: clientSecret,
          customerEphemeralKeySecret: null,
          customerId: null,
          style: ThemeMode.system,
          billingDetails: customerName != null
              ? BillingDetails(
                  name: customerName,
                )
              : null,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: null,
            ),
          ),
          primaryButtonLabel: 'Pagar',
          removeSavedPaymentMethodMessage: null,
          allowsDelayedPaymentMethods: false,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      // 3. Extract payment intent ID from client secret
      final paymentIntentId = _extractPaymentIntentId(clientSecret);

      return paymentIntentId;
    } catch (e) {
      rethrow;
    }
  }

  /// Get payment status
  Future<Map<String, dynamic>> getPaymentStatus(String paymentIntentId) async {
    return await _paymentApiClient.getPaymentStatus(paymentIntentId);
  }

  /// Extract payment intent ID from client secret
  String _extractPaymentIntentId(String clientSecret) {
    // Client secret format: pi_xxxxx_secret_yyyy
    final parts = clientSecret.split('_secret_');
    if (parts.isEmpty) {
      throw Exception('Invalid client secret format');
    }
    return parts[0];
  }
}
