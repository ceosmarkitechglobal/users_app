// lib/features/profile/view/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _privateProfile = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notifications = prefs.getBool('notifications') ?? true;
      _privateProfile = prefs.getBool('privateProfile') ?? false;
    });
  }

  Future<void> _updateSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("$key updated")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),

        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFF571094),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Enable Notifications"),
            value: _notifications,
            onChanged: (v) {
              setState(() => _notifications = v);
              _updateSetting('notifications', v);
            },
          ),
          SwitchListTile(
            title: const Text("Private Profile"),
            value: _privateProfile,
            onChanged: (v) {
              setState(() => _privateProfile = v);
              _updateSetting('privateProfile', v);
            },
          ),
        ],
      ),
    );
  }
}
