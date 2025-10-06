import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/ads_model.dart';
import '../data/ads_repository.dart';

final adsRepositoryProvider = Provider((ref) => AdsRepository());

final adsListProvider = FutureProvider.autoDispose<List<AdModel>>((ref) async {
  final repo = ref.read(adsRepositoryProvider);
  return repo.getAllAds();
});
