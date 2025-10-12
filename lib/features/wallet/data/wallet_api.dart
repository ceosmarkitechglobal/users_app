import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WalletApi {
  static const String baseUrl =
      "https://telugu-net-backend2.onrender.com/api/wallet";
  static const _secureStorage = FlutterSecureStorage();

  /// 🔐 Get JWT token from secure storage
  static Future<String?> _getToken() async {
    return await _secureStorage.read(key: "jwt_token");
  }

  /// 🔹 Get wallet balance
  static Future<int> getWalletBalance() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/balance"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["data"]["walletBalance"] ?? 0;
    } else {
      throw Exception("Failed to fetch wallet balance");
    }
  }

  static Future<List<Map<String, dynamic>>> getTransactionHistory() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/transactions"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> transactions = json["data"];
      return transactions.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to fetch transactions");
    }
  }

  /// 🔹 Recharge wallet
  static Future<int> rechargeWallet(int amount) async {
    final token = await _getToken();
    if (token == null) throw Exception("User not authenticated");

    final response = await http.post(
      Uri.parse("$baseUrl/recharge"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"amount": amount}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["newBalance"] ?? 0;
    } else {
      throw Exception("Recharge failed: ${response.body}");
    }
  }

  /// 🔹 Make payment
  static Future<int> makePayment(int amount) async {
    final token = await _getToken();
    if (token == null) throw Exception("User not authenticated");

    final response = await http.post(
      Uri.parse("$baseUrl/pay"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"amount": amount}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["newBalance"] ?? 0;
    } else {
      throw Exception("Payment failed: ${response.body}");
    }
  }

  /// 🔹 Apply cashback
  static Future<int> applyCashback(int cashback) async {
    final token = await _getToken();
    if (token == null) throw Exception("User not authenticated");

    final response = await http.post(
      Uri.parse("$baseUrl/cashback"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"cashback": cashback}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["newBalance"] ?? 0;
    } else {
      throw Exception("Failed to apply cashback: ${response.body}");
    }
  }
}
