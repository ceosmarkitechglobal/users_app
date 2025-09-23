import 'package:flutter/material.dart';
import '../../features/splash/view/splash_screen.dart';
import '../../features/home/view/user_home.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const UserSplashScreen(),
  '/userHome': (context) => const UserHome(),
};
