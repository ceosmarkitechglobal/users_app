import 'dart:convert';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../data/user_model.dart';

/// ✅ Provides current JWT token
final jwtTokenProvider = FutureProvider<String?>((ref) async {
  const storage = FlutterSecureStorage();
  return await storage.read(key: 'jwt_token');
});
final updateUserProfileProvider =
    FutureProvider.family<bool, Map<String, dynamic>>((ref, updatedData) async {
      final token = await ref.read(jwtTokenProvider.future);
      if (token == null) throw Exception("Not logged in");

      final response = await http.put(
        Uri.parse("https://telugu-net-backend2.onrender.com/api/users/profile"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(updatedData),
      );

      return response.statusCode == 200;
    });

/// ✅ Provides user profile using current token (with retry logic)
final userProfileProvider = FutureProvider<UserModel>((ref) async {
  const maxRetries = 5;
  int attempts = 0;
  String? token;

  // ⏳ Wait for token to become available (if recently logged in)
  while (attempts < maxRetries) {
    token = await ref.read(jwtTokenProvider.future);
    if (token != null && token.isNotEmpty) break;
    await Future.delayed(const Duration(milliseconds: 300));
    attempts++;
  }

  if (token == null || token.isEmpty) {
    throw Exception('User not logged in');
  }

  final response = await http.get(
    Uri.parse('https://telugu-net-backend2.onrender.com/api/users/profile'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return UserModel.fromJson(data);
  } else if (response.statusCode == 404) {
    // Backend might return 404 briefly if token hasn't propagated yet
    await Future.delayed(const Duration(milliseconds: 300));
    // Optional: retry once
    final retryResponse = await http.get(
      Uri.parse('https://telugu-net-backend2.onrender.com/api/users/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (retryResponse.statusCode == 200) {
      final data = jsonDecode(retryResponse.body);
      return UserModel.fromJson(data);
    }
    throw Exception('User not found');
  } else {
    throw Exception('Failed to load profile');
  }
});
