class FoodItem {
  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.restaurantId,
    required this.restaurantName,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.prepTimeMinutes,
    this.isPopular = false,
    this.isVegetarian = false,
    this.calories = 0,
    this.ingredients = const [],
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String restaurantId;
  final String restaurantName;
  final String category;
  final double rating;
  final int reviewCount;
  final int prepTimeMinutes;
  final bool isPopular;
  final bool isVegetarian;
  final int calories;
  final List<String> ingredients;

  FoodItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? restaurantId,
    String? restaurantName,
    String? category,
    double? rating,
    int? reviewCount,
    int? prepTimeMinutes,
    bool? isPopular,
    bool? isVegetarian,
    int? calories,
    List<String>? ingredients,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      isPopular: isPopular ?? this.isPopular,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      calories: calories ?? this.calories,
      ingredients: ingredients ?? this.ingredients,
    );
  }
}
