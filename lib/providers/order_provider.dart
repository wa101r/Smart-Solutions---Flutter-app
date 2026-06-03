import 'package:flutter/foundation.dart';

import '../models/order.dart';
import 'cart_provider.dart';

/// Holds the user's order history. Seeded with a couple of past orders so the
/// history screen isn't empty on first run.
class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [
    Order(
      id: 'PO-10231',
      lines: const [
        OrderLine(name: 'KYOCERA ECOSYS P3155dn', qty: 2, price: 24500),
        OrderLine(name: 'Sigfox 0G IoT Sensor Kit', qty: 4, price: 5900),
      ],
      total: 72600,
      status: OrderStatus.delivered,
      placedAt: DateTime.now().subtract(const Duration(days: 18)),
    ),
    Order(
      id: 'PO-10288',
      lines: const [
        OrderLine(name: 'PANASONIC PT-VMZ51 Projector', qty: 1, price: 41900),
      ],
      total: 41900,
      status: OrderStatus.shipping,
      placedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  List<Order> get orders => List.unmodifiable(_orders.reversed);
  int get count => _orders.length;
  double get lifetimeSpend => _orders.fold(0, (s, o) => s + o.total);

  /// Create an order from the current cart contents.
  Order checkout(CartProvider cart) {
    final order = Order(
      id: 'PO-${10300 + _orders.length}',
      lines: [
        for (final i in cart.items) OrderLine.fromProduct(i.product, i.qty),
      ],
      total: cart.total,
      status: OrderStatus.confirmed,
      placedAt: DateTime.now(),
    );
    _orders.add(order);
    notifyListeners();
    return order;
  }
}
