import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/wallet_api.dart';

class WalletState {
  final int balance;
  final List<Map<String, dynamic>> history;
  final bool loading;
  final String? error;

  WalletState({
    required this.balance,
    required this.history,
    this.loading = false,
    this.error,
  });

  WalletState copyWith({
    int? balance,
    List<Map<String, dynamic>>? history,
    bool? loading,
    String? error,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      history: history ?? this.history,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class WalletNotifier extends StateNotifier<WalletState> {
  WalletNotifier() : super(WalletState(balance: 1000, history: []));
  Future<void> fetchWallet(String userId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final balance = await WalletApi.getWalletBalance(userId);
      final history = await WalletApi.getTransactionHistory(userId);
      state = state.copyWith(
        balance: balance,
        history: history,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  Future<void> recharge(String userId, int amount) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final newBalance = await WalletApi.rechargeWallet(userId, amount);
      final newHistory = List<Map<String, dynamic>>.from(state.history)
        ..insert(0, {
          "type": "credit",
          "amount": amount,
          "date": DateTime.now().toString().split(".")[0],
        });

      state = state.copyWith(
        balance: newBalance,
        history: newHistory,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Fetch wallet history
  Future<void> fetchHistory(String userId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final history = await WalletApi.getTransactionHistory(userId);
      state = state.copyWith(history: history, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Make payment (QR payment)
  Future<void> makePayment(String userId, int amount) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final newBalance = await WalletApi.makePayment(userId, amount);
      state = state.copyWith(balance: newBalance, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
      rethrow;
    }
  }

  /// Apply cashback after payment
  Future<void> applyCashback(String userId, int cashback) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final newBalance = await WalletApi.applyCashback(userId, cashback);
      state = state.copyWith(balance: newBalance, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
      rethrow;
    }
  }
}

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>(
  (ref) => WalletNotifier(),
);
