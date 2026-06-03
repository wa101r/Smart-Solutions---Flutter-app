import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../core/design_tokens.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/gradient_button.dart';
import 'order_confirmation_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final baht =
        NumberFormat.currency(locale: 'th_TH', symbol: '฿', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: cart.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : ListView.separated(
              itemCount: cart.items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final item = cart.items[i];
                return ListTile(
                  title: Text(item.product.name),
                  subtitle: Text(baht.format(item.subtotal)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () =>
                            context.read<CartProvider>().decrement(item.product.id),
                      ),
                      Text('${item.qty}'),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () =>
                            context.read<CartProvider>().add(item.product),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Total',
                              style: Theme.of(context).textTheme.bodySmall),
                          Text(baht.format(cart.total),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.indigo)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 160,
                      child: GradientButton(
                        label: 'Checkout',
                        icon: Icons.check_rounded,
                        onPressed: () {
                          final cartProvider = context.read<CartProvider>();
                          final order = context
                              .read<OrderProvider>()
                              .checkout(cartProvider);
                          cartProvider.clear();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) =>
                                  OrderConfirmationScreen(order: order),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
