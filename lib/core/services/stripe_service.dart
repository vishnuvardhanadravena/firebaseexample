import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  final String stripeSecret = String.fromEnvironment("STRIPE_SECRET");
  final String _publishableKey = String.fromEnvironment(
    "STRIPE_PUBLISHABLE_KEY",
  );

  static const String _paymentIntentUrl =
      "https://your-domain.com/api/create-payment-intent";

  final Dio _dio = Dio();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    Stripe.publishableKey = _publishableKey;

    await Stripe.instance.applySettings();

    _initialized = true;
  }

  Future<bool> makePayment({
    required int amount,
    required String currency,
    String merchantName = "My Store",
    ThemeMode themeMode = ThemeMode.system,
  }) async {
    try {
      await initialize();
      final supported = await isPlatformPaySupported();
      debugPrint("Google Pay Supported: $supported");

      final paymentData = await _getClientSecret(
        amount: amount,
        currency: currency,
      );

      if (paymentData == null) {
        debugPrint("Unable to get client secret.");
        return false;
      }

      final clientSecret = paymentData["client_secret"] as String;
      final paymentIntentId = paymentData["id"] as String;

      /// Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: merchantName,
          paymentIntentClientSecret: clientSecret,
          style: themeMode,
          allowsDelayedPaymentMethods: true,

          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: "US",
            currencyCode: "USD",
            testEnv: true, // false in production
          ),
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      final paymentIntent = await getPaymentIntent(paymentIntentId);

      if (paymentIntent != null) {
        final status = paymentIntent["status"];

        debugPrint("Payment Status: $status");

        if (status == "succeeded") {
          debugPrint("✅ Payment Successful");
        } else if (status == "processing") {
          debugPrint("⏳ Payment Processing");
        } else if (status == "requires_payment_method") {
          debugPrint("❌ Payment Failed");
        } else if (status == "canceled") {
          debugPrint("🚫 Payment Cancelled");
        }
      }

      return true;
    } on StripeException catch (e) {
      debugPrint("Stripe Error: ${e.error.localizedMessage}");
      return false;
    } catch (e) {
      debugPrint("Payment Error : $e");
      return false;
    }
  }

  Future<Map<String, dynamic>?> _createPaymentIntent({
    required int amount,
    required String currency,
  }) async {
    try {
      final body = {
        "amount": _calculateAmount(amount),
        "currency": currency,
        "automatic_payment_methods": {"enabled": true},
      };

      final response = await _dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: body,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Authorization": "Bearer  secret key"},
        ),
      );

      debugPrint("Create intent data a=============>${response.data}");
      return response.data;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>?> getPaymentIntent(String paymentIntentId) async {
    try {
      final response = await _dio.get(
        "https://api.stripe.com/v1/payment_intents/$paymentIntentId",
        options: Options(headers: {"Authorization": "Bearer $stripeSecret"}),
      );

      debugPrint("Payment Intent => ${response.data}");
      return response.data;
    } catch (e) {
      debugPrint("Get Payment Intent Error: $e");
      return null;
    }
  }

  // Future<String?> _getClientSecret({
  //   required int amount,
  //   required String currency,
  // }) async {
  //   try {
  //     final response = await _dio.post(
  //       _paymentIntentUrl,
  //       data: {"amount": amount, "currency": currency},
  //     );

  //     if (response.statusCode == 200) {
  //       return response.data["client_secret"];
  //     }

  //     return null;
  //   } catch (e, s) {
  //     debugPrint("${e}==================${s}");
  //     final paymentIntent = await _createPaymentIntent(
  //       amount: amount,
  //       currency: currency,
  //     );

  //     if (paymentIntent == null) {
  //       return null;
  //     }

  //     debugPrint("Client Secret Error : $e");
  //     return paymentIntent["client_secret"];
  //   }
  // }
  Future<Map<String, dynamic>?> _getClientSecret({
    required int amount,
    required String currency,
  }) async {
    final paymentIntent = await _createPaymentIntent(
      amount: amount,
      currency: currency,
    );

    if (paymentIntent == null) {
      return null;
    }

    debugPrint("PaymentIntent: $paymentIntent");

    return paymentIntent;
  }

  ///-------------------------------------------------------
  /// Create Payment Method
  ///-------------------------------------------------------
  Future<PaymentMethod> createPaymentMethod() async {
    return Stripe.instance.createPaymentMethod(
      params: const PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(),
      ),
    );
  }

  ///-------------------------------------------------------
  /// Confirm Payment
  ///-------------------------------------------------------
  Future<void> confirmPayment(String clientSecret) async {
    await Stripe.instance.confirmPayment(
      paymentIntentClientSecret: clientSecret,
      data: const PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(),
      ),
    );
  }

  ///-------------------------------------------------------
  /// Create Token
  ///-------------------------------------------------------
  Future<TokenData> createToken() async {
    return Stripe.instance.createToken(
      const CreateTokenParams.card(params: CardTokenParams()),
    );
  }

  ///-------------------------------------------------------
  /// Handle 3DS
  ///-------------------------------------------------------
  Future<void> handleNextAction(String clientSecret) async {
    await Stripe.instance.handleNextAction(clientSecret);
  }

  ///-------------------------------------------------------
  /// Google Pay / Apple Pay Support
  ///-------------------------------------------------------
  Future<bool> isPlatformPaySupported() async {
    return Stripe.instance.isPlatformPaySupported();
  }

  String _calculateAmount(int amount) {
    return (amount * 100).toString();
  }
}
