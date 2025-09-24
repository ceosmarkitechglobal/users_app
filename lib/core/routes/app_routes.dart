import 'package:flutter/material.dart';
import 'package:userside_app/features/auth/screens/login_screen.dart';
import '../../features/splash/view/splash_screen.dart';
import '../../features/home/view/user_home.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const UserSplashScreen(),
  '/login': (context) => const LoginScreen(),
  '/userHome': (context) => const UserHome(),
};
