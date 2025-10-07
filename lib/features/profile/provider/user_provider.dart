import 'package:flutter_riverpod/flutter_riverpod.dart';

/// User data providers (placeholders for now)
final userNameProvider = StateProvider<String>((ref) => 'John Doe');
final userEmailProvider = StateProvider<String>(
  (ref) => 'john.doe@example.com',
);
final userPhoneProvider = StateProvider<String>((ref) => '+91 9000000000');
