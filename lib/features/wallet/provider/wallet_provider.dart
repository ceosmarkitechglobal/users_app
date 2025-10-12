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
  WalletNotifier() : super(WalletState(balance: 0, history: []));

  /// 🔹 Fetch wallet balance + transaction history
  Future<void> fetchWallet() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final balance = await WalletApi.getWalletBalance();
      final history = await WalletApi.getTransactionHistory();
      state = state.copyWith(
        balance: balance,
        history: history,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// 🔹 Recharge wallet
  Future<void> recharge(int amount) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final newBalance = await WalletApi.rechargeWallet(amount);
      final history = await WalletApi.getTransactionHistory();
      state = state.copyWith(
        balance: newBalance,
        history: history,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// 🔹 Make payment
  Future<void> makePayment(int amount) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final newBalance = await WalletApi.makePayment(amount);
      final history = await WalletApi.getTransactionHistory();
      state = state.copyWith(
        balance: newBalance,
        history: history,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
      rethrow;
    }
  }

  /// 🔹 Apply cashback
  Future<void> applyCashback(int cashback) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final newBalance = await WalletApi.applyCashback(cashback);
      final history = await WalletApi.getTransactionHistory();
      state = state.copyWith(
        balance: newBalance,
        history: history,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
      rethrow;
    }
  }

  /// 🔹 Fetch only wallet history
  Future<void> fetchHistory() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final history = await WalletApi.getTransactionHistory();
      state = state.copyWith(history: history, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }
}

/// 🔹 Provider
final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>(
  (ref) => WalletNotifier(),
);
