import 'ads_model.dart';

class AdsRepository {
  Future<List<AdModel>> getAllAds({String? category, String? location}) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      AdModel(
        id: '1',
        title: 'Mega Diwali Sale',
        description: 'Up to 60% off on all items!',
        imageUrl:
            'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=800',
        category: 'Festival',
        location: 'Mumbai',
      ),
      AdModel(
        id: '2',
        title: 'Gadget Fest',
        description: 'Best prices on electronics',
        imageUrl:
            'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=800',
        category: 'Electronics',
        location: 'Delhi',
      ),
      AdModel(
        id: '3',
        title: 'Mega Diwali Sale',
        description: 'Up to 60% off on all items!',
        imageUrl:
            'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=800',
        category: 'Festival',
        location: 'Mumbai',
      ),
      AdModel(
        id: '4',
        title: 'Gadget Fest',
        description: 'Best prices on electronics',
        imageUrl:
            'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=800',
        category: 'Electronics',
        location: 'Delhi',
      ),
    ];
  }
}
