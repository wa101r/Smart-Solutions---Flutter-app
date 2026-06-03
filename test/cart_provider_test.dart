import 'package:flutter_test/flutter_test.dart';
import 'package:smart_solutions/models/product.dart';
import 'package:smart_solutions/providers/cart_provider.dart';

const _p1 = Product(
  id: 'p1',
  name: 'Copier',
  category: 'Copiers',
  price: 100,
  description: '',
  imageUrl: '',
);
const _p2 = Product(
  id: 'p2',
  name: 'Printer',
  category: 'Printers',
  price: 50,
  description: '',
  imageUrl: '',
);

void main() {
  group('CartProvider', () {
    late CartProvider cart;
    setUp(() => cart = CartProvider());

    test('starts empty', () {
      expect(cart.isEmpty, true);
      expect(cart.count, 0);
      expect(cart.total, 0);
    });

    test('adding the same product increments quantity', () {
      cart.add(_p1);
      cart.add(_p1);
      expect(cart.count, 2);
      expect(cart.items.length, 1);
      expect(cart.total, 200);
    });

    test('total sums distinct products', () {
      cart.add(_p1);
      cart.add(_p2);
      expect(cart.total, 150);
      expect(cart.count, 2);
    });

    test('decrement removes item when quantity hits zero', () {
      cart.add(_p1);
      cart.decrement('p1');
      expect(cart.isEmpty, true);
    });

    test('clear empties the cart', () {
      cart.add(_p1);
      cart.add(_p2);
      cart.clear();
      expect(cart.isEmpty, true);
    });
  });
}
