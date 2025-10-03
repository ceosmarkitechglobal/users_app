import 'package:flutter/material.dart';

class QRScreen extends StatelessWidget {
  const QRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF571094),
      ),
      body: const Center(
        child: Text("QR Screen!", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
