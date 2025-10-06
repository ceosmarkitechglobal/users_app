import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:userside_app/features/auth/data/auth_api.dart';

enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? message;
  final String? token; // final JWT token after OTP verified

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

  String? phoneNumber;
  String? _otpToken; // temporary OTP token received after sendOtp

  /// SEND OTP
  Future<void> sendOtp(String phone) async {
    phoneNumber = phone;
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final response = await AuthApi.sendOtp(phone);
      _otpToken = response['token']; // temporary OTP token from backend

      state = state.copyWith(
        status: AuthStatus.success,
        message: response['message'] ?? "OTP sent successfully",
      );
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, message: e.toString());
    }
  }

  /// VERIFY OTP
  Future<void> verifyOtp(String code) async {
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
        // store final JWT token
        state = state.copyWith(
          status: AuthStatus.success,
          message: "OTP Verified",
          token: response['token'],
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
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
