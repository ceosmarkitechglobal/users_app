// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

class UserSplashScreen extends StatelessWidget {
  const UserSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/userHome');
    });

    return Scaffold(
      body: Center(
        child: Text(
          "User App Splash Screen",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
