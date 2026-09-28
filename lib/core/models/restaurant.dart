class Restaurant {
  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.coverUrl,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTimeMinutes,
    required this.deliveryFee,
    required this.categories,
    required this.distanceKm,
    this.isFeatured = false,
    this.isOpen = true,
  });

  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String coverUrl;
  final double rating;
  final int reviewCount;
  final int deliveryTimeMinutes;
  final double deliveryFee;
  final List<String> categories;
  final double distanceKm;
  final bool isFeatured;
  final bool isOpen;
}
