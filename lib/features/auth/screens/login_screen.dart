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
              const Spacer(),
              const Icon(Icons.phone_android, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text("Enter your mobile number to continue"),
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
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: authState.status == AuthStatus.loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Send OTP"),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
