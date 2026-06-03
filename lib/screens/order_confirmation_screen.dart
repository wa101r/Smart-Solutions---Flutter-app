import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/design_tokens.dart';
import '../models/order.dart';
import '../widgets/gradient_button.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key, required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final baht =
        NumberFormat.currency(locale: 'th_TH', symbol: '฿', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Order placed')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Container(
              height: 84,
              width: 84,
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                shape: BoxShape.circle,
                boxShadow: AppShadows.card,
              ),
              child: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 48),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Thank you!',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800)),
          Text('Order ${order.id} · ${order.status.label}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                for (final l in order.lines)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(child: Text('${l.name}  ×${l.qty}')),
                        Text(baht.format(l.subtotal)),
                      ],
                    ),
                  ),
                const Divider(),
                Row(
                  children: [
                    const Expanded(
                      child: Text('Total',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    Text(baht.format(order.total),
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.indigo)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          GradientButton(
            label: 'Continue shopping',
            onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
          ),
        ],
      ),
    );
  }
}
