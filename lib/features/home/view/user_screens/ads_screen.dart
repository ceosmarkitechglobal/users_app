import 'package:flutter/material.dart';

class AdsScreen extends StatelessWidget {
  const AdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ads", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF571094),
      ),
      body: const Center(
        child: Text("Ads Screen!", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
