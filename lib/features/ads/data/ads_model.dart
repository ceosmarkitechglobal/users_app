class AdModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final String location;

  AdModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.location,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? '',
      location: json['location'] ?? '',
    );
  }
}
