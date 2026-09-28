import 'package:flutter/foundation.dart';

import '../models/food_item.dart';
import 'food_service.dart';

class FavoritesService extends ChangeNotifier {
  FavoritesService._();
  static final FavoritesService instance = FavoritesService._();

  final Set<String> _favoriteIds = {'f1', 'f3', 'f5', 'f9'};

  List<FoodItem> get favorites {
    return FoodService.instance
        .getFoods()
        .where((f) => _favoriteIds.contains(f.id))
        .toList();
  }

  bool isFavorite(String foodId) => _favoriteIds.contains(foodId);

  void toggleFavorite(String foodId) {
    if (_favoriteIds.contains(foodId)) {
      _favoriteIds.remove(foodId);
    } else {
      _favoriteIds.add(foodId);
    }
    notifyListeners();
  }
}
