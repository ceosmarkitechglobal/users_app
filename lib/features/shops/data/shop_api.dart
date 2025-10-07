class ShopApi {
  // Simulated backend data store (for demo)
  static final Map<String, List<Map<String, dynamic>>> _shopReviews = {
    "1": [
      {
        "name": "Ethan Carter",
        "timeAgo": "1 month ago",
        "rating": 5,
        "comment":
            "Excellent service and knowledgeable staff. Highly recommend!",
        "likes": 15,
        "replies": 2,
      },
      {
        "name": "Sophia Lee",
        "timeAgo": "2 weeks ago",
        "rating": 4,
        "comment": "Cozy place with great coffee. Would visit again!",
        "likes": 8,
        "replies": 1,
      },
    ],
    "2": [],
    "3": [],
  };

  // --- Nearby shops ---
  static Future<List<Map<String, dynamic>>> getNearbyShops() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      {
        "id": "1",
        "name": "The Daily Grind",
        "category": "Coffee Shop",
        "rating": 4.5,
        "location": "123 Innovation Drive, Tech City",
        "image":
            "https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=800",
      },
      {
        "id": "2",
        "name": "Urban Cuts Saloon",
        "category": "Saloon",
        "rating": 4.2,
        "location": "42 Downtown Street, Metro City",
        "image":
            "https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=800",
      },
      {
        "id": "3",
        "name": "Fresh Mart Grocery",
        "category": "Grocery",
        "rating": 4.7,
        "location": "77 Market Road, River Town",
        "image":
            "https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=800",
      },
    ];
  }

  // --- Shop details ---
  static Future<Map<String, dynamic>> getShopDetails(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      "id": id,
      "name": "The Daily Grind",
      "category": "Coffee Shop",
      "rating": 4.5,
      "reviewsCount": _shopReviews[id]?.length ?? 0,
      "location": "123 Innovation Drive, Tech City",
      "description":
          "Lorem ipsum dolor sit amet consectetur. Faucibus molestie quam nisl rhoncus. "
          "Purus nisi malesuada diam tellus tellus. Amet vitae neque in eu consequat nisi egestas.",
      "image":
          "https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=800",
      "reviews": _shopReviews[id] ?? [],
      "ratingSummary": {"5": 0.4, "4": 0.3, "3": 0.15, "2": 0.1, "1": 0.05},
    };
  }

  // --- Get reviews for a shop ---
  static Future<List<Map<String, dynamic>>> getShopReviews(
    String shopId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _shopReviews[shopId] ?? [];
  }

  // --- Add a new review ---
  static Future<void> addReview(
    String shopId,
    String userId,
    double rating,
    String comment,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));

    // Dummy new review
    final newReview = {
      "name": "User $userId",
      "timeAgo": "Just now",
      "rating": rating,
      "comment": comment,
      "likes": 0,
      "replies": 0,
    };

    _shopReviews.putIfAbsent(shopId, () => []);
    _shopReviews[shopId]!.insert(0, newReview);
  }
}
