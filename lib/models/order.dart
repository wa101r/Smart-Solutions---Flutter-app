import 'product.dart';

enum OrderStatus { pending, confirmed, shipping, delivered }

extension OrderStatusInfo on OrderStatus {
  String get label => switch (this) {
        OrderStatus.pending => 'Pending',
        OrderStatus.confirmed => 'Confirmed',
        OrderStatus.shipping => 'Shipping',
        OrderStatus.delivered => 'Delivered',
      };
}

class OrderLine {
  const OrderLine({required this.name, required this.qty, required this.price});
  final String name;
  final int qty;
  final double price;
  double get subtotal => qty * price;

  factory OrderLine.fromProduct(Product p, int qty) =>
      OrderLine(name: p.name, qty: qty, price: p.price);
}

class Order {
  Order({
    required this.id,
    required this.lines,
    required this.total,
    required this.status,
    required this.placedAt,
  });

  final String id;
  final List<OrderLine> lines;
  final double total;
  final OrderStatus status;
  final DateTime placedAt;

  int get itemCount => lines.fold(0, (s, l) => s + l.qty);
}
