import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:userside_app/features/qr_payment/view/transaction_result_screen.dart';
import 'package:userside_app/features/wallet/provider/wallet_provider.dart';

class QrPaymentScreen extends ConsumerStatefulWidget {
  const QrPaymentScreen({super.key});

  @override
  ConsumerState<QrPaymentScreen> createState() => _QrPaymentScreenState();
}

class _QrPaymentScreenState extends ConsumerState<QrPaymentScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _isProcessing = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  void _onQRViewCreated(QRViewController ctrl) {
    controller = ctrl;
    controller!.scannedDataStream.listen((scanData) async {
      if (_isProcessing) return;
      _isProcessing = true;

      final code = scanData.code;
      if (code == null) {
        _isProcessing = false;
        return;
      }

      // Only accept UPI payment URLs
      if (!code.startsWith("upi://pay")) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Not a valid payment QR code")),
        );
        _isProcessing = false;
        return;
      }

      // Ask user to enter amount manually
      int? amount = await _showAmountDialog();
      if (amount == null || amount <= 0) {
        _isProcessing = false;
        return;
      }

      String result = "Payment Failed";

      try {
        // Make payment using wallet
        await ref.read(walletProvider.notifier).makePayment("user123", amount);

        // Apply cashback (dummy 10%)
        final cashback = (amount * 0.1).toInt();
        await ref
            .read(walletProvider.notifier)
            .applyCashback("user123", cashback);

        result = "Payment Successful\nCashback ₹$cashback added";
      } catch (e) {
        result = "Payment Failed: ${e.toString()}";
      }

      if (!mounted) return;

      // Navigate to result screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QrResultScreen(result: result, amount: amount),
        ),
      );
    });
  }

  Future<int?> _showAmountDialog() async {
    int? amount;
    final controller = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Enter Amount"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "Amount"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              amount = int.tryParse(controller.text);
              Navigator.pop(context);
            },
            child: const Text("Pay"),
          ),
        ],
      ),
    );

    return amount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Payment QR"),
        backgroundColor: const Color(0xFF571094),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.purple,
          borderRadius: 12,
          borderLength: 30,
          borderWidth: 8,
          cutOutSize: 250,
        ),
      ),
    );
  }
}
