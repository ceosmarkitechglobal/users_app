import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../provider/wallet_provider.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(walletProvider.notifier).fetchWallet();
    });
  }

  String formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return "";
    try {
      final dateTime = DateTime.parse(isoDate);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Wallet",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFF571094),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Wallet Balance Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Container(
                width: double.infinity,
                height: 135,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Wallet Balance",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "₹${walletState.balance}",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF571094),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Recharge Button
            ElevatedButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/recharge');
                ref.read(walletProvider.notifier).fetchWallet();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF571094),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "Recharge Wallet",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Transaction History",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF571094),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Transaction List
            Expanded(
              child: walletState.loading
                  ? const Center(child: CircularProgressIndicator())
                  : walletState.history.isEmpty
                  ? const Center(child: Text("No transactions yet"))
                  : ListView.builder(
                      itemCount: walletState.history.length,
                      itemBuilder: (context, index) {
                        final txn = walletState.history[index];

                        // Null-safe
                        final direction =
                            txn["direction"]?.toString() ?? "credit";
                        final type = txn["type"]?.toString() ?? "unknown";
                        final amount = txn["amount"]?.toString() ?? "0";
                        final date = formatDate(txn["createdAt"]?.toString());

                        return ListTile(
                          leading: Icon(
                            direction == "credit"
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: direction == "credit"
                                ? Colors.green
                                : Colors.red,
                          ),
                          title: Text("₹$amount"),
                          subtitle: Text(date),
                          trailing: Text(type.toUpperCase()),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
