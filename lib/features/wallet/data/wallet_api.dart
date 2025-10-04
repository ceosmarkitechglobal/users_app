class WalletApi {
  static int _balance = 1000;
  static final List<Map<String, dynamic>> _history = [
    {"id": 1, "amount": 500, "type": "credit", "date": "2023-10-01"},
    {"id": 2, "amount": 200, "type": "debit", "date": "2023-10-05"},
  ];

  /// Recharge wallet (dummy backend)
  static Future<int> rechargeWallet(String userId, int amount) async {
    await Future.delayed(const Duration(seconds: 2));
    _balance += amount;
    _history.insert(0, {
      "id": _history.length + 1,
      "amount": amount,
      "type": "credit",
      "date": DateTime.now().toString().split(" ")[0],
    });
    return _balance;
  }

  /// Make payment for QR transaction
  static Future<int> makePayment(String userId, int amount) async {
    await Future.delayed(const Duration(seconds: 2));
    if (amount > _balance) throw Exception("Insufficient balance");
    _balance -= amount;
    _history.insert(0, {
      "id": _history.length + 1,
      "amount": amount,
      "type": "debit",
      "date": DateTime.now().toString().split(" ")[0],
    });
    return _balance;
  }

  /// Apply cashback
  static Future<int> applyCashback(String userId, int cashback) async {
    await Future.delayed(const Duration(seconds: 1));
    _balance += cashback;
    _history.insert(0, {
      "id": _history.length + 1,
      "amount": cashback,
      "type": "credit",
      "date": DateTime.now().toString().split(" ")[0],
    });
    return _balance;
  }

  /// Fetch current wallet balance
  static Future<int> getWalletBalance(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return _balance;
  }

  /// Fetch transaction history
  static Future<List<Map<String, dynamic>>> getTransactionHistory(
    String userId,
  ) async {
    await Future.delayed(const Duration(microseconds: 100));
    return _history;
  }
}
