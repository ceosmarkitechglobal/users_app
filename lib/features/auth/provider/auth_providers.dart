import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { idle, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? message;

  AuthState({this.status = AuthStatus.idle, this.message});

  AuthState copyWith({AuthStatus? status, String? message}) {
    return AuthState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  String? _phoneNumber;

  void sendOtp(String phoneNumber) {
    state = AuthState(status: AuthStatus.loading);
    _phoneNumber = phoneNumber;

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      state = AuthState(
        status: AuthStatus.success,
        message: "OTP sent to $phoneNumber",
      );
    });
  }

  void verifyOtp(String otp) {
    state = AuthState(status: AuthStatus.loading);

    Future.delayed(const Duration(seconds: 2), () {
      if (otp == "123456") {
        state = AuthState(status: AuthStatus.success, message: "OTP Verified");
      } else {
        state = AuthState(status: AuthStatus.error, message: "Invalid OTP");
      }
    });
  }

  String? get phoneNumber => _phoneNumber;
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
