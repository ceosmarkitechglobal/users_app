import 'package:flutter/material.dart';
import 'package:userside_app/features/auth/screens/login_screen.dart';
import 'package:userside_app/features/splash/view/app_logo.dart';
import '../../features/home/view/user_home.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => const LoginScreen(),
  '/userHome': (context) => const UserHome(),
  '/logosplash': (context) => const LogoSplashScreen(),
};
