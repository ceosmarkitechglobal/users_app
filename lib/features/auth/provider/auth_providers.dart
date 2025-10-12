import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/auth_api.dart';
import '../../profile/provider/user_provider.dart';

enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? message;
  final String? token;

  AuthState({required this.status, this.message, this.token});

  factory AuthState.initial() => AuthState(status: AuthStatus.initial);

  AuthState copyWith({AuthStatus? status, String? message, String? token}) {
    return AuthState(
      status: status ?? this.status,
      message: message ?? this.message,
      token: token ?? this.token,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.initial());

  final _secureStorage = const FlutterSecureStorage();
  String? phoneNumber;
  String? _otpToken;

  /// Step 1: Send OTP
  Future<void> sendOtp(String phone) async {
    phoneNumber = phone;
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final response = await AuthApi.sendOtp(phone);
      _otpToken = response['token'];

      state = state.copyWith(
        status: AuthStatus.success,
        message: response['message'] ?? "OTP sent successfully",
      );
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, message: e.toString());
    }
  }

  /// Step 2: Verify OTP + Save Token Securely + Refresh User Data
  Future<void> verifyOtp(String code, WidgetRef ref) async {
    if (_otpToken == null || phoneNumber == null) {
      state = state.copyWith(
        status: AuthStatus.error,
        message: "Missing OTP token or phone number",
      );
      return;
    }

    state = state.copyWith(status: AuthStatus.loading);

    try {
      final response = await AuthApi.verifyOtp(_otpToken!, code);

      if (response['success'] == true || response['token'] != null) {
        final jwt = response['token'];

        // ✅ Store JWT securely
        await _secureStorage.write(key: 'jwt_token', value: jwt);

        // ✅ Refresh providers to fetch latest data
        ref.invalidate(jwtTokenProvider);
        ref.invalidate(userProfileProvider);

        // ✅ Wait briefly to ensure providers are updated
        await Future.delayed(const Duration(milliseconds: 300));

        // ✅ Update auth state
        state = state.copyWith(
          status: AuthStatus.success,
          message: "OTP Verified",
          token: jwt,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          message: response['message'] ?? "OTP verification failed",
        );
      }
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, message: e.toString());
    }
  }

  /// Read stored JWT
  Future<String?> getStoredToken() async {
    return await _secureStorage.read(key: 'jwt_token');
  }

  /// Clear JWT (Logout)
  Future<void> clearStoredToken(WidgetRef ref) async {
    await _secureStorage.delete(key: 'jwt_token');
    ref.invalidate(jwtTokenProvider);
    ref.invalidate(userProfileProvider);
    state = AuthState.initial();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
