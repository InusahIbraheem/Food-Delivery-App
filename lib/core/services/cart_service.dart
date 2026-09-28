import 'package:flutter/foundation.dart';

import '../constants/app_constants.dart';
import '../models/cart_item.dart';
import '../models/food_item.dart';

class CartService extends ChangeNotifier {
  CartService._();
  static final CartService instance = CartService._();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee =>
      _items.isEmpty ? 0 : AppConstants.deliveryFee;

  double get tax => subtotal * AppConstants.taxRate;

  double get total => subtotal + deliveryFee + tax;

  bool get isEmpty => _items.isEmpty;

  void addItem(FoodItem food, {int quantity = 1}) {
    final index = _items.indexWhere((item) => item.food.id == food.id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + quantity,
      );
    } else {
      _items.add(CartItem(food: food, quantity: quantity));
    }
    notifyListeners();
  }

  void removeItem(String foodId) {
    _items.removeWhere((item) => item.food.id == foodId);
    notifyListeners();
  }

  void updateQuantity(String foodId, int quantity) {
    if (quantity <= 0) {
      removeItem(foodId);
      return;
    }
    final index = _items.indexWhere((item) => item.food.id == foodId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
