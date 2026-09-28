import '../models/food_item.dart';
import '../models/restaurant.dart';

class FoodService {
  FoodService._();
  static final FoodService instance = FoodService._();

  static const List<String> categories = [
    'All',
    'Burger',
    'Pizza',
    'Sushi',
    'Salad',
    'Dessert',
    'Drinks',
  ];

  final List<Restaurant> _restaurants = const [
    Restaurant(
      id: 'r1',
      name: 'Burger Palace',
      description: 'Gourmet burgers crafted with premium ingredients',
      imageUrl: 'https://images.unsplash.com/photo-1571091718767-18b5b1457a0?w=400',
      coverUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800',
      rating: 4.8,
      reviewCount: 1240,
      deliveryTimeMinutes: 25,
      deliveryFee: 1.99,
      categories: ['Burger', 'Fast Food'],
      distanceKm: 1.2,
      isFeatured: true,
    ),
    Restaurant(
      id: 'r2',
      name: 'Pizza Napoli',
      description: 'Authentic Neapolitan pizza baked in wood-fired ovens',
      imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
      coverUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=800',
      rating: 4.6,
      reviewCount: 890,
      deliveryTimeMinutes: 35,
      deliveryFee: 2.49,
      categories: ['Pizza', 'Italian'],
      distanceKm: 2.5,
      isFeatured: true,
    ),
    Restaurant(
      id: 'r3',
      name: 'Sushi Zen',
      description: 'Fresh sushi and Japanese cuisine by master chefs',
      imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
      coverUrl: 'https://images.unsplash.com/photo-1553621042-f6e147245754?w=800',
      rating: 4.9,
      reviewCount: 2100,
      deliveryTimeMinutes: 40,
      deliveryFee: 3.99,
      categories: ['Sushi', 'Japanese'],
      distanceKm: 3.1,
      isFeatured: true,
    ),
    Restaurant(
      id: 'r4',
      name: 'Green Bowl',
      description: 'Healthy salads and nourishing bowls',
      imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
      coverUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
      rating: 4.5,
      reviewCount: 560,
      deliveryTimeMinutes: 20,
      deliveryFee: 1.49,
      categories: ['Salad', 'Healthy'],
      distanceKm: 0.8,
    ),
    Restaurant(
      id: 'r5',
      name: 'Sweet Delights',
      description: 'Artisan desserts and handcrafted pastries',
      imageUrl: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400',
      coverUrl: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=800',
      rating: 4.7,
      reviewCount: 430,
      deliveryTimeMinutes: 30,
      deliveryFee: 2.99,
      categories: ['Dessert', 'Bakery'],
      distanceKm: 1.8,
    ),
  ];

  final List<FoodItem> _foods = const [
    FoodItem(
      id: 'f1',
      name: 'Classic Smash Burger',
      description:
          'Double patty smash burger with aged cheddar, caramelized onions, and secret sauce on a brioche bun.',
      price: 14.99,
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600',
      restaurantId: 'r1',
      restaurantName: 'Burger Palace',
      category: 'Burger',
      rating: 4.9,
      reviewCount: 342,
      prepTimeMinutes: 15,
      isPopular: true,
      calories: 680,
      ingredients: ['Beef', 'Cheddar', 'Brioche Bun', 'Secret Sauce'],
    ),
    FoodItem(
      id: 'f2',
      name: 'Truffle Fries',
      description: 'Crispy golden fries tossed with truffle oil, parmesan, and fresh herbs.',
      price: 7.99,
      imageUrl: 'https://images.unsplash.com/photo-1573080496219-b9980812cf84?w=600',
      restaurantId: 'r1',
      restaurantName: 'Burger Palace',
      category: 'Burger',
      rating: 4.7,
      reviewCount: 198,
      prepTimeMinutes: 10,
      isVegetarian: true,
      calories: 420,
      ingredients: ['Potato', 'Truffle Oil', 'Parmesan'],
    ),
    FoodItem(
      id: 'f3',
      name: 'Margherita Pizza',
      description:
          'San Marzano tomatoes, fresh mozzarella, basil, and extra virgin olive oil on thin crust.',
      price: 16.99,
      imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=600',
      restaurantId: 'r2',
      restaurantName: 'Pizza Napoli',
      category: 'Pizza',
      rating: 4.8,
      reviewCount: 567,
      prepTimeMinutes: 20,
      isPopular: true,
      isVegetarian: true,
      calories: 820,
      ingredients: ['Tomato', 'Mozzarella', 'Basil', 'Olive Oil'],
    ),
    FoodItem(
      id: 'f4',
      name: 'Pepperoni Feast',
      description: 'Loaded with premium pepperoni, mozzarella, and our signature tomato sauce.',
      price: 18.99,
      imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=600',
      restaurantId: 'r2',
      restaurantName: 'Pizza Napoli',
      category: 'Pizza',
      rating: 4.6,
      reviewCount: 423,
      prepTimeMinutes: 22,
      calories: 950,
      ingredients: ['Pepperoni', 'Mozzarella', 'Tomato Sauce'],
    ),
    FoodItem(
      id: 'f5',
      name: 'Dragon Roll',
      description: 'Tempura shrimp, avocado, eel, and spicy mayo topped with thin avocado slices.',
      price: 22.99,
      imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=600',
      restaurantId: 'r3',
      restaurantName: 'Sushi Zen',
      category: 'Sushi',
      rating: 4.9,
      reviewCount: 789,
      prepTimeMinutes: 18,
      isPopular: true,
      calories: 380,
      ingredients: ['Shrimp', 'Avocado', 'Eel', 'Rice'],
    ),
    FoodItem(
      id: 'f6',
      name: 'Salmon Nigiri Set',
      description: 'Premium Norwegian salmon nigiri served with wasabi, ginger, and soy sauce.',
      price: 19.99,
      imageUrl: 'https://images.unsplash.com/photo-1617195737868-060c5d2a5d97?w=600',
      restaurantId: 'r3',
      restaurantName: 'Sushi Zen',
      category: 'Sushi',
      rating: 4.8,
      reviewCount: 456,
      prepTimeMinutes: 15,
      calories: 320,
      ingredients: ['Salmon', 'Rice', 'Wasabi', 'Ginger'],
    ),
    FoodItem(
      id: 'f7',
      name: 'Mediterranean Bowl',
      description:
          'Quinoa, grilled chicken, feta, olives, cucumber, and lemon herb dressing.',
      price: 13.99,
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600',
      restaurantId: 'r4',
      restaurantName: 'Green Bowl',
      category: 'Salad',
      rating: 4.5,
      reviewCount: 234,
      prepTimeMinutes: 12,
      isPopular: true,
      calories: 450,
      ingredients: ['Quinoa', 'Chicken', 'Feta', 'Olives'],
    ),
    FoodItem(
      id: 'f8',
      name: 'Acai Power Bowl',
      description: 'Organic acai blend topped with granola, banana, berries, and honey.',
      price: 11.99,
      imageUrl: 'https://images.unsplash.com/photo-1590301157890-4810ed352733?w=600',
      restaurantId: 'r4',
      restaurantName: 'Green Bowl',
      category: 'Salad',
      rating: 4.6,
      reviewCount: 167,
      prepTimeMinutes: 8,
      isVegetarian: true,
      calories: 380,
      ingredients: ['Acai', 'Granola', 'Banana', 'Berries'],
    ),
    FoodItem(
      id: 'f9',
      name: 'Chocolate Lava Cake',
      description: 'Warm chocolate cake with a molten center, served with vanilla ice cream.',
      price: 9.99,
      imageUrl: 'https://images.unsplash.com/photo-1624353365286-3f8d62daad51?w=600',
      restaurantId: 'r5',
      restaurantName: 'Sweet Delights',
      category: 'Dessert',
      rating: 4.9,
      reviewCount: 312,
      prepTimeMinutes: 10,
      isPopular: true,
      isVegetarian: true,
      calories: 520,
      ingredients: ['Dark Chocolate', 'Butter', 'Vanilla Ice Cream'],
    ),
    FoodItem(
      id: 'f10',
      name: 'Fresh Mango Smoothie',
      description: 'Blended ripe mangoes with yogurt, honey, and a hint of lime.',
      price: 6.99,
      imageUrl: 'https://images.unsplash.com/photo-1505252587547-135973addeb1?w=600',
      restaurantId: 'r5',
      restaurantName: 'Sweet Delights',
      category: 'Drinks',
      rating: 4.4,
      reviewCount: 89,
      prepTimeMinutes: 5,
      isVegetarian: true,
      calories: 210,
      ingredients: ['Mango', 'Yogurt', 'Honey', 'Lime'],
    ),
  ];

  List<Restaurant> getRestaurants() => List.unmodifiable(_restaurants);

  List<Restaurant> getFeaturedRestaurants() =>
      _restaurants.where((r) => r.isFeatured).toList();

  Restaurant? getRestaurantById(String id) {
    try {
      return _restaurants.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  List<FoodItem> getFoods() => List.unmodifiable(_foods);

  List<FoodItem> getPopularFoods() =>
      _foods.where((f) => f.isPopular).toList();

  FoodItem? getFoodById(String id) {
    try {
      return _foods.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  List<FoodItem> getFoodsByRestaurant(String restaurantId) =>
      _foods.where((f) => f.restaurantId == restaurantId).toList();

  List<FoodItem> getFoodsByCategory(String category) {
    if (category == 'All') return getFoods();
    return _foods.where((f) => f.category == category).toList();
  }

  List<FoodItem> searchFoods(String query) {
    if (query.isEmpty) return getFoods();
    final lower = query.toLowerCase();
    return _foods.where((f) {
      return f.name.toLowerCase().contains(lower) ||
          f.restaurantName.toLowerCase().contains(lower) ||
          f.category.toLowerCase().contains(lower);
    }).toList();
  }
}
