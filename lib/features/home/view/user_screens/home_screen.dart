// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:userside_app/features/profile/view/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFF571094),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.person,
                  size: 25,
                  color: Color(0xFF571094),
                ),
              ),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text("Home Screen!", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
