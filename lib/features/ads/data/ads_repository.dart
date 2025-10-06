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
            'https://d3jbu7vaxvlagf.cloudfront.net/small/v2/category_media/basic_img_16863173257673.jpg',
        category: 'Festival',
        location: 'Mumbai',
      ),
      AdModel(
        id: '2',
        title: 'Gadget Fest',
        description: 'Best prices on electronics',
        imageUrl:
            'https://d3jbu7vaxvlagf.cloudfront.net/small/v2/category_media/basic_img_16833608561304.jpg',
        category: 'Electronics',
        location: 'Delhi',
      ),
      AdModel(
        id: '3',
        title: 'Mega Diwali Sale',
        description: 'Up to 60% off on all items!',
        imageUrl:
            'https://5.imimg.com/data5/SELLER/Default/2024/7/437925870/DE/GO/HG/202005434/mobile-recharge-software-service-500x500.jpeg',
        category: 'Festival',
        location: 'Mumbai',
      ),
      AdModel(
        id: '4',
        title: 'Gadget Fest',
        description: 'Best prices on electronics',
        imageUrl:
            'https://d3jbu7vaxvlagf.cloudfront.net/small/v2/category_media/image_17091993168241.jpeg',
        category: 'Electronics',
        location: 'Delhi',
      ),
    ];
  }
}
