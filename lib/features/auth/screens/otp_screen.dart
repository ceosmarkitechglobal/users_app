// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userside_app/features/auth/provider/auth_providers.dart';

class OtpScreen extends ConsumerWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final otpController = TextEditingController();
    final phone = ref.read(authProvider.notifier).phoneNumber ?? "";

    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    ref.listen<AuthState>(authProvider, (previous, next) async {
      if (next.status == AuthStatus.success && next.message == "OTP Verified") {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/userHome',
          (route) => false,
        );

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Login Successful ✅")));
      }
      if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.message!)));
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(),
              //const Icon(Icons.lock, size: 80, color: Colors.blue),
              Image.asset('assets/logo/Logo.png', width: 150, height: 150),
              //const SizedBox(height: 20),
              //const Text(
              // "Enter OTP",
              // style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              //),
              const SizedBox(height: 10),
              Text("Enter the OTP that we had sent to \nyour number +91$phone"),
              const SizedBox(height: 30),

              // Pinput OTP field
              Pinput(
                controller: otpController,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFF571094)),
                  ),
                ),
                submittedPinTheme: defaultPinTheme,
                showCursor: true,
                onCompleted: (pin) {
                  ref.read(authProvider.notifier).verifyOtp(pin.trim());
                },
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: authState.status == AuthStatus.loading
                    ? null
                    : () {
                        ref
                            .read(authProvider.notifier)
                            .verifyOtp(otpController.text.trim());
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF571094),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: authState.status == AuthStatus.loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Verify OTP",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  ref.read(authProvider.notifier).sendOtp(phone);
                },
                child: const Text(
                  "Didn’t receive code? Resend",
                  style: TextStyle(color: Color(0xFF571094)),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
