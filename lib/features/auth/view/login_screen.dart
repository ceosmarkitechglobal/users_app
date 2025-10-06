import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:userside_app/features/auth/provider/auth_providers.dart';
import 'otp_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    // Listen for text changes to refresh button enable state
    phoneController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  bool get isPhoneValid {
    final phone = phoneController.text.trim();
    return RegExp(r'^[0-9]{10}$').hasMatch(phone); // Only 10 digits
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.success &&
          (next.message?.toLowerCase().contains("otp sent") ?? false)) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OtpScreen()),
        );
      } else if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message ?? "Something went wrong")),
        );
      }
    });

    final bool isEnabled = isPhoneValid && _isChecked;
    final Color buttonColor = isEnabled ? const Color(0xFF571094) : Colors.grey;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Image.asset('assets/logo/Logo.png', width: 150, height: 150),
              const SizedBox(height: 20),
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
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: InputDecoration(
                  prefixText: '+91 ',
                  prefixStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  counterText: "",
                  hintText: "Enter 10-digit number",
                  labelText: "Mobile Number",
                  border: const OutlineInputBorder(),
                  errorText: phoneController.text.isEmpty
                      ? null
                      : (!isPhoneValid ? "Enter valid 10-digit number" : null),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    activeColor: const Color(0xFF571094),
                    onChanged: isPhoneValid
                        ? (value) {
                            setState(() {
                              _isChecked = value ?? false;
                            });
                          }
                        : null,
                  ),
                  Expanded(
                    child: Text(
                      "I agree to the Terms & Conditions",
                      style: TextStyle(
                        fontSize: 14,
                        color: isPhoneValid ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      (!isEnabled || authState.status == AuthStatus.loading)
                      ? null
                      : () {
                          final phone = phoneController.text.trim();
                          final formattedPhone =
                              '+91$phone'; // ✅ Auto add country code
                          ref
                              .read(authProvider.notifier)
                              .sendOtp(formattedPhone);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: authState.status == AuthStatus.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Send OTP",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
