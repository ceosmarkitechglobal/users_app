class UserModel {
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;
  final int? walletBalance;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
    this.walletBalance,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] ?? {};
    return UserModel(
      name: userJson['name'] ?? '',
      email: userJson['email'] ?? '',
      phone: userJson['phone'] ?? '',
      avatarUrl: userJson['avatarUrl'],
      walletBalance: userJson['walletBalance'] != null
          ? int.tryParse(userJson['walletBalance'].toString())
          : null,
    );
  }
}
