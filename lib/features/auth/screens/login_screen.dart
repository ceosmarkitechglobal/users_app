import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:userside_app/features/auth/provider/auth_providers.dart';
import 'otp_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final phoneController = TextEditingController();

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.success &&
          next.message!.contains("OTP sent")) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OtpScreen()),
        );
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
              Image.asset('assets/logo/Logo.png', width: 150, height: 150),
              const Text(
                "Sign Up With OTP",
                style: TextStyle(
                  color: Color(0xFF571094),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Please Enter Your Mobile Number",
                style: TextStyle(color: Color(0xFF737373)),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  prefixText: "+91 ",
                  labelText: "Mobile Number",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: authState.status == AuthStatus.loading
                    ? null
                    : () {
                        ref
                            .read(authProvider.notifier)
                            .sendOtp(phoneController.text.trim());
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF571094),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: authState.status == AuthStatus.loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Send OTP",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
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
