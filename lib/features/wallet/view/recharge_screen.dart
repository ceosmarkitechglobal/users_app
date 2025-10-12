// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/wallet_provider.dart';

class RechargeScreen extends ConsumerStatefulWidget {
  const RechargeScreen({super.key});

  @override
  ConsumerState<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends ConsumerState<RechargeScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Recharge Wallet",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFF571094),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Amount",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            /// 🔹 Recharge Button
            ElevatedButton(
              onPressed: walletState.loading
                  ? null
                  : () async {
                      final amount =
                          int.tryParse(_amountController.text.trim()) ?? 0;

                      if (amount <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter a valid amount"),
                          ),
                        );
                        return;
                      }

                      try {
                        await ref
                            .read(walletProvider.notifier)
                            .recharge(amount);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Wallet recharged successfully ✅"),
                            backgroundColor: Colors.green,
                          ),
                        );

                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Recharge failed: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF571094),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: walletState.loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Recharge with UPI",
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
