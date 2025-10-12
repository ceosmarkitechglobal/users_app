// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userside_app/features/auth/provider/auth_providers.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final phone = ref.read(authProvider.notifier).phoneNumber ?? "";

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
      } else if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message ?? "Something went wrong")),
        );
      }
    });

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF571094)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Back", style: TextStyle(color: Color(0xFF571094))),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Image.asset('assets/logo/Logo.png', width: 120),
              const SizedBox(height: 20),
              const Text(
                "OTP Verification",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF571094),
                ),
              ),
              const SizedBox(height: 10),
              Text("Enter the OTP sent to $phone"),
              const SizedBox(height: 20),
              Pinput(
                controller: otpController,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                onCompleted: (pin) {
                  ref.read(authProvider.notifier).verifyOtp(pin.trim(), ref);
                },
              ),
              const SizedBox(height: 20),
              _secondsRemaining > 0
                  ? Text(
                      "Resend OTP in $_secondsRemaining s",
                      style: const TextStyle(color: Colors.grey),
                    )
                  : TextButton(
                      onPressed: () {
                        // ✅ Automatically reformat number with +91 if missing
                        final cleanPhone = phone.replaceAll(
                          RegExp(r'[^0-9]'),
                          '',
                        );
                        final formattedPhone = phone.startsWith('+91')
                            ? phone
                            : '+91$cleanPhone';
                        ref.read(authProvider.notifier).sendOtp(formattedPhone);
                        _startTimer();
                      },
                      child: const Text(
                        "Resend OTP",
                        style: TextStyle(
                          color: Color(0xFF571094),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: authState.status == AuthStatus.loading
                      ? null
                      : () {
                          ref
                              .read(authProvider.notifier)
                              .verifyOtp(otpController.text.trim(), ref);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF571094),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: authState.status == AuthStatus.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Verify OTP",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
