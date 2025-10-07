import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/shop_api.dart';

/// --- STATE CLASS ---
class ShopState {
  final List<Map<String, dynamic>> shops;
  final Map<String, dynamic>? selectedShop;
  final List<Map<String, dynamic>> reviews;
  final bool loading;
  final String? error;

  ShopState({
    required this.shops,
    this.selectedShop,
    this.reviews = const [],
    this.loading = false,
    this.error,
  });

  ShopState copyWith({
    List<Map<String, dynamic>>? shops,
    Map<String, dynamic>? selectedShop,
    List<Map<String, dynamic>>? reviews,
    bool? loading,
    String? error,
  }) {
    return ShopState(
      shops: shops ?? this.shops,
      selectedShop: selectedShop ?? this.selectedShop,
      reviews: reviews ?? this.reviews,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

/// --- NOTIFIER ---
class ShopNotifier extends StateNotifier<ShopState> {
  ShopNotifier() : super(ShopState(shops: [], selectedShop: null));

  /// Load list of shops
  Future<void> loadShops() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final shops = await ShopApi.getNearbyShops();
      state = state.copyWith(shops: shops, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Load shop details
  Future<void> loadShopDetails(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final details = await ShopApi.getShopDetails(id);
      state = state.copyWith(selectedShop: details, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// --- REVIEWS SECTION ---
  /// Fetch all reviews for a shop
  Future<void> loadReviews(String shopId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final reviews = await ShopApi.getShopReviews(shopId);
      state = state.copyWith(reviews: reviews, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Add a new review
  Future<void> addReview({
    required String shopId,
    required String userId,
    required double rating,
    required String comment,
  }) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await ShopApi.addReview(shopId, userId, rating, comment);

      // Refresh reviews after posting
      final updatedReviews = await ShopApi.getShopReviews(shopId);
      state = state.copyWith(reviews: updatedReviews, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }
}

/// --- PROVIDERS ---
final shopProvider = StateNotifierProvider<ShopNotifier, ShopState>(
  (ref) => ShopNotifier(),
);

/// category filter
final selectedCategoryProvider = StateProvider<String>((ref) => "All");

/// search query
final searchQueryProvider = StateProvider<String>((ref) => "");
