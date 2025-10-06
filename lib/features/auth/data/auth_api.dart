import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApi {
  static const String baseUrl =
      "https://telugu-net-backend2.onrender.com/api/auth"; // updated

  /// SEND OTP
  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    final url = Uri.parse('$baseUrl/request-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"phone": phone}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to send OTP: ${response.statusCode} ${response.body}',
      );
    }
  }

  /// VERIFY OTP
  static Future<Map<String, dynamic>> verifyOtp(
    String otpToken,
    String otpCode,
  ) async {
    final url = Uri.parse('$baseUrl/verify-otp');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $otpToken',
      },
      body: jsonEncode({"code": otpCode}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to verify OTP: ${response.statusCode} ${response.body}',
      );
    }
  }
}
