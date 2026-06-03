import 'package:flutter/foundation.dart';

import '../models/product.dart';

class CartItem {
  CartItem(this.product, this.qty);
  final Product product;
  int qty;
  double get subtotal => product.price * qty;
}

/// Shopping-cart state. Pure Dart logic — unit-tested in test/cart_provider_test.dart.
class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();
  int get count => _items.values.fold(0, (sum, i) => sum + i.qty);
  double get total => _items.values.fold(0, (sum, i) => sum + i.subtotal);
  bool get isEmpty => _items.isEmpty;

  void add(Product product) {
    final existing = _items[product.id];
    if (existing != null) {
      existing.qty++;
    } else {
      _items[product.id] = CartItem(product, 1);
    }
    notifyListeners();
  }

  void decrement(String productId) {
    final item = _items[productId];
    if (item == null) return;
    if (item.qty > 1) {
      item.qty--;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void remove(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
