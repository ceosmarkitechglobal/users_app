// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:userside_app/features/home/provider/nav_provider.dart';
import '../provider/shop_provider.dart';
import '../../qr_payment/view/qr_payment_screen.dart';

const purple = Color(0xFF571094);

class ShopDetailScreen extends ConsumerStatefulWidget {
  final String shopId;
  const ShopDetailScreen({super.key, required this.shopId});

  @override
  ConsumerState<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends ConsumerState<ShopDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(shopProvider.notifier).loadShopDetails(widget.shopId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shopProvider);
    final shop = state.selectedShop;

    if (state.loading || shop == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final reviews = shop["reviews"] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            ref.read(navIndexProvider.notifier).state = 1;
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),

        title: Text(
          shop["name"],
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share, color: Colors.black),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          SizedBox(
            height: 220,
            child: PageView.builder(
              itemCount: 3,
              itemBuilder: (context, i) => ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  shop["image"],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == 0 ? purple : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),
          const Text(
            "About",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: purple,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            shop["description"] ??
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),

          const SizedBox(height: 18),

          _infoRow("Address", shop["location"] ?? "—"),
          const SizedBox(height: 8),
          _infoRow("Phone Number", "+91-9876543210"),
          const SizedBox(height: 8),
          _infoRow("Hours", "Mon - Fri : 9am - 7pm\nSat - Sun : 10am - 6pm"),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 160,
              color: Colors.grey[200],
              child: Center(
                child: Text(
                  "Map Placeholder",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () async {
              final Uri mapUri = Uri.parse(
                "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(shop["location"] ?? "")}",
              );
              if (await canLaunchUrl(mapUri)) {
                await launchUrl(mapUri);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: purple,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Get Directions",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 12),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QrPaymentScreen()),
              );
            },
            icon: const Icon(Icons.qr_code),
            label: const Text("Scan to Pay"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: purple,
              side: const BorderSide(color: purple),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            "Customer Reviews",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: purple,
            ),
          ),
          const SizedBox(height: 12),

          if (reviews.isEmpty)
            const Text(
              "No reviews yet. Be the first to review this shop!",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            )
          else
            Column(children: reviews.map((r) => _reviewCard(r)).toList()),

          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: () async {
              await ref
                  .read(shopProvider.notifier)
                  .addReview(
                    shopId: widget.shopId,
                    userId: "Guest",
                    rating: 5,
                    comment: "Amazing place!",
                  );
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Review added!")));
            },
            icon: const Icon(Icons.rate_review_outlined, color: Colors.white),
            label: const Text(
              "Add Review",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: purple,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            "$label :",
            style: const TextStyle(color: purple, fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(child: Text(content, style: const TextStyle(fontSize: 15))),
      ],
    );
  }

  Widget _reviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundColor: purple,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review["name"] ?? "Anonymous",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    ...List.generate(
                      (review["rating"] ?? 0).toInt(),
                      (i) =>
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                    ),
                    ...List.generate(
                      (5 - ((review["rating"] ?? 0).toInt())).toInt(),
                      (i) => const Icon(
                        Icons.star_border,
                        color: Colors.amber,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      review["timeAgo"] ?? "",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  review["comment"] ?? "",
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up_alt_outlined,
                      color: Colors.grey[600],
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text("${review["likes"] ?? 0}"),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.reply_outlined,
                      color: Colors.grey[600],
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text("${review["replies"] ?? 0} replies"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
