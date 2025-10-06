// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:userside_app/features/ads/view/ads_list_screen.dart';
import 'package:userside_app/features/qr_payment/view/qr_payment_screen.dart';
import 'package:userside_app/features/wallet/view/wallet_screen.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import '../provider/nav_provider.dart';
import 'user_screens/home_screen.dart';

class UserHome extends ConsumerWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navIndexProvider);

    final screens = const [
      HomeScreen(),
      WalletScreen(),
      QrPaymentScreen(),
      AdsListScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFF571094),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => ref.read(navIndexProvider.notifier).state = index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: "Wallet",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: "QR"),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: "Ads"),
        ],
      ),
    );
  }
}
