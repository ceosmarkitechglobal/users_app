import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:userside_app/features/home/provider/nav_provider.dart';

class QrResultScreen extends ConsumerWidget {
  final String result;
  final int amount;

  const QrResultScreen({super.key, required this.result, required this.amount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSuccess = result.contains("Successful");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Result",style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF571094),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                size: 80,
                color: isSuccess ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 24),
              Text(
                result,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);

                  ref.read(navIndexProvider.notifier).state = 1;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF571094),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Back to Wallet"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
