import 'package:flutter/material.dart';
import 'package:userside_app/features/auth/view/login_screen.dart';
import 'package:userside_app/features/auth/view/otp_screen.dart';
import 'package:userside_app/features/qr_payment/view/qr_payment_screen.dart';
import 'package:userside_app/features/wallet/view/wallet_screen.dart';
import 'package:userside_app/features/splash/view/app_logo.dart';
import 'package:userside_app/features/wallet/view/recharge_screen.dart';
import '../../features/home/view/bottom_navbar.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => const LoginScreen(),
  '/userHome': (context) => const UserHome(),
  '/logosplash': (context) => const LogoSplashScreen(),
  '/wallet': (context) => const WalletScreen(),
  '/recharge': (context) => const RechargeScreen(),
  '/otp': (context) => const OtpScreen(),
  '/qr_payment': (context) => const QrPaymentScreen(),
};
