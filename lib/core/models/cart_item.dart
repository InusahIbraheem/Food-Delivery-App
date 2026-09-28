import 'food_item.dart';

class CartItem {
  const CartItem({
    required this.food,
    required this.quantity,
    this.specialInstructions = '',
  });

  final FoodItem food;
  final int quantity;
  final String specialInstructions;

  double get totalPrice => food.price * quantity;

  CartItem copyWith({
    FoodItem? food,
    int? quantity,
    String? specialInstructions,
  }) {
    return CartItem(
      food: food ?? this.food,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}
