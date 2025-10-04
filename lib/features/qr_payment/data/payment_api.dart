// ignore_for_file: dead_code

import 'dart:async';

class PaymentApi {
  static Future<Map<String, dynamic>> processPayment({
    required String userId,
    required String merchantId,
    required int amount,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    final success = true; // For testing purpose.
    final cashback = (amount * 0.05).toInt();
    final newBalance = 1000 - amount + cashback;

    return {
      "success": success,
      "message": success
          ? "Payment Successful"
          : "Payment Failed. Please try again.",
      "transactionId": DateTime.now().millisecondsSinceEpoch.toString(),
      "cashback": cashback,
      "newBalance": newBalance,
    };
  }
}
