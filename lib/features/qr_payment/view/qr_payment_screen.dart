// ignore_for_file: deprecated_member_use

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
    _isProcessing = false;
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

      if (!code.startsWith("upi://pay")) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Not a valid payment QR code")),
        );
        _isProcessing = false;
        return;
      }

      // Pause camera while taking amount input
      await controller?.pauseCamera();

      int? amount = await _showAmountDialog();

      // Resume camera regardless of result
      await controller?.resumeCamera();

      if (amount == null || amount <= 0) {
        _isProcessing = false;
        return;
      }

      String result = "Payment Failed";

      try {
        // Make payment
        await ref.read(walletProvider.notifier).makePayment(amount);

        final cashback = (amount * 0.1).toInt();
        await ref.read(walletProvider.notifier).applyCashback(cashback);

        result = "Payment Successful\nCashback ₹$cashback added";
      } catch (e) {
        result = "Payment Failed: ${e.toString()}";
      }

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QrResultScreen(result: result, amount: amount),
        ),
      );

      _isProcessing = false;
    });
  }

  Future<int?> _showAmountDialog() async {
    int? amount;
    final controller = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "Enter Amount",
          style: TextStyle(
            color: Color(0xFF571094),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: "Amount",
            hintStyle: TextStyle(color: Colors.grey[400]),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF571094)),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF571094), width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Color(0xFF571094)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF571094),
            ),
            onPressed: () {
              final parsed = int.tryParse(controller.text);
              if (parsed == null || parsed <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Enter a valid amount")),
                );
                return;
              }
              amount = parsed;
              Navigator.pop(context);
            },
            child: const Text("Pay", style: TextStyle(color: Colors.white)),
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
        title: const Text(
          "Scan Payment QR",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
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
