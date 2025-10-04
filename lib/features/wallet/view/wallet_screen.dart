import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    // Fetch initial balance & history
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(walletProvider.notifier).fetchWallet("user123");
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wallet", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF571094),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
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
                ref.read(walletProvider.notifier).fetchWallet("user123");
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
            Expanded(
              child: walletState.loading
                  ? const Center(child: CircularProgressIndicator())
                  : walletState.history.isEmpty
                  ? const Center(child: Text("No transactions yet"))
                  : ListView.builder(
                      itemCount: walletState.history.length,
                      itemBuilder: (context, index) {
                        final txn = walletState.history[index];
                        return ListTile(
                          leading: Icon(
                            txn["type"] == "credit"
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: txn["type"] == "credit"
                                ? Colors.green
                                : Colors.red,
                          ),
                          title: Text("₹${txn["amount"]}"),
                          subtitle: Text(txn["date"]),
                          trailing: Text(txn["type"].toUpperCase()),
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
