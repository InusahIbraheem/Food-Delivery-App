import 'package:flutter/foundation.dart';

import '../constants/app_constants.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import 'cart_service.dart';

class OrderService extends ChangeNotifier {
  OrderService._();
  static final OrderService instance = OrderService._();

  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  Order? getLatestOrder() => _orders.isEmpty ? null : _orders.first;

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  Order placeOrder({
    required List<CartItem> items,
    required String deliveryAddress,
    required String restaurantName,
  }) {
    final subtotal = items.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );
    final deliveryFee = AppConstants.deliveryFee;
    final tax = subtotal * AppConstants.taxRate;
    final total = subtotal + deliveryFee + tax;

    final order = Order(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      items: List.from(items),
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      tax: tax,
      total: total,
      status: OrderStatus.confirmed,
      createdAt: DateTime.now(),
      deliveryAddress: deliveryAddress,
      restaurantName: restaurantName,
      estimatedDeliveryMinutes: 30,
    );

    _orders.insert(0, order);
    CartService.instance.clear();
    notifyListeners();
    return order;
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      final existing = _orders[index];
      _orders[index] = Order(
        id: existing.id,
        items: existing.items,
        subtotal: existing.subtotal,
        deliveryFee: existing.deliveryFee,
        tax: existing.tax,
        total: existing.total,
        status: status,
        createdAt: existing.createdAt,
        deliveryAddress: existing.deliveryAddress,
        restaurantName: existing.restaurantName,
        estimatedDeliveryMinutes: existing.estimatedDeliveryMinutes,
      );
      notifyListeners();
    }
  }
}
