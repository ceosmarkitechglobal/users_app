import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:userside_app/features/auth/auth_api.dart';

enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? message;

  AuthState({required this.status, this.message});

  factory AuthState.initial() => AuthState(status: AuthStatus.initial);

  AuthState copyWith({AuthStatus? status, String? message}) {
    return AuthState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.initial());

  String? phoneNumber;

  Future<void> sendOtp(String phone) async {
    phoneNumber = phone;
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final response = await AuthApi.sendOtp(phone);
      if (response['success'] == true) {
        state = state.copyWith(
          status: AuthStatus.success,
          message: response['message'],
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          message: response['message'],
        );
      }
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, message: e.toString());
    }
  }

  Future<void> verifyOtp(String otp) async {
    if (phoneNumber == null) return;
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final response = await AuthApi.verifyOtp(phoneNumber!, otp);
      if (response['success'] == true) {
        state = state.copyWith(
          status: AuthStatus.success,
          message: "OTP Verified",
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          message: response['message'],
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
