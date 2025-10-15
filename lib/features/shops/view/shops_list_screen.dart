import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:userside_app/features/shops/view/shop_details.dart';
import '../../home/provider/nav_provider.dart';
import '../provider/shop_provider.dart';

const purple = Color(0xFF571094);

class ShopListScreen extends ConsumerStatefulWidget {
  const ShopListScreen({super.key});

  @override
  ConsumerState<ShopListScreen> createState() => _ShopListScreenState();
}

class _ShopListScreenState extends ConsumerState<ShopListScreen> {
  final categories = ["All", "Grocery", "Saloon", "Food", "Medicine", "Shops"];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(shopProvider.notifier).loadShops();
    });
  }

  @override
  Widget build(BuildContext context) {
    final shopState = ref.watch(shopProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    final filtered = shopState.shops.where((s) {
      final matchesCategory = selectedCategory == "All"
          ? true
          : s["category"].toString().toLowerCase() ==
                selectedCategory.toLowerCase();
      final matchesSearch = s["name"].toString().toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            children: [
              // Top row: title + toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          ref.read(navIndexProvider.notifier).state = 0;
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFF571094),
                        ),
                      ),
                      const Text(
                        "Nearby Shops",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  // (Optional) List/Map toggle - can be re-enabled later
                  /* Row(
      children: [
        const Text("List"),
        const SizedBox(width: 6),
        Switch(
          value: false,
          onChanged: (_) {},
          activeThumbColor: Color(0xFF571094),
        ),
        const Text("Map"),
      ],
    )*/
                ],
              ),

              const SizedBox(height: 12),

              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) =>
                          ref.read(searchQueryProvider.notifier).state = v,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: purple,
                          size: 20,
                        ),
                        hintText: "Search Saloon's",
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  //IconButton(
                  //onPressed: () {},
                  // icon: const Icon(Icons.tune, color: Colors.black54),
                  //),
                ],
              ),

              const SizedBox(height: 12),

              // Category chips
              SizedBox(
                height: 46,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected = selectedCategory == cat;
                    return ChoiceChip(
                      label: Row(
                        children: [
                          if (cat == "Grocery") const Text('🛒 '),
                          if (cat == "Saloon") const Text('✂️ '),
                          if (cat == "Food") const Text('🍽 '),
                          if (cat == "Medicine") const Text('💊 '),
                          Text(cat),
                        ],
                      ),
                      selected: isSelected,
                      selectedColor: purple,
                      backgroundColor: Colors.white,
                      elevation: 1,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      onSelected: (_) =>
                          ref.read(selectedCategoryProvider.notifier).state =
                              cat,
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // List / grid of cards
              Expanded(
                child: shopState.loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, i) {
                          final shop = filtered[i];
                          return _ShopCard(
                            shop: shop,
                            onTapView: () {
                              // make sure bottom nav highlights Shop tab
                              ref.read(navIndexProvider.notifier).state = 1;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ShopDetailScreen(shopId: shop["id"]),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShopCard extends StatelessWidget {
  final Map<String, dynamic> shop;
  final VoidCallback onTapView;

  const _ShopCard({required this.shop, required this.onTapView});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image with rounded corners
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                shop["image"],
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),

            // promo chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: purple,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                "10% off",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    shop["name"],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                InkWell(
                  onTap: onTapView,
                  child: const Text(
                    "View Details",
                    style: TextStyle(
                      color: purple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.blue),
                const SizedBox(width: 6),
                Text(
                  "${shop["rating"]} (${(shop["rating"] * 30).toInt()} reviews)",
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "${shop["category"]} · 0.3 mi",
              style: const TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
