import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/design_tokens.dart';
import '../models/product.dart';

final _baht = NumberFormat.currency(locale: 'th_TH', symbol: '฿', decimalDigits: 0);

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.onTap, this.onAdd});

  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.border),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.indigo.withValues(alpha: 0.10),
                          AppColors.violet.withValues(alpha: 0.10),
                        ],
                      ),
                    ),
                    child: Icon(_iconFor(product.category),
                        size: 46, color: AppColors.indigo),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(product.category,
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 13, height: 1.2)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(_baht.format(product.price),
                            style: const TextStyle(
                                color: AppColors.indigo,
                                fontWeight: FontWeight.w800)),
                      ),
                      _AddButton(
                        enabled: product.inStock,
                        onAdd: onAdd,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.circle,
                          size: 8,
                          color:
                              product.inStock ? AppColors.success : AppColors.danger),
                      const SizedBox(width: 4),
                      Text(product.inStock ? 'In stock' : 'Out of stock',
                          style: TextStyle(
                            fontSize: 11,
                            color: product.inStock
                                ? AppColors.success
                                : AppColors.danger,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String category) => switch (category) {
        'Copiers' => Icons.print,
        'Printers' => Icons.print_outlined,
        'IoT' => Icons.sensors,
        'Projectors' => Icons.videocam,
        'POS' => Icons.point_of_sale,
        _ => Icons.devices_other,
      };
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.enabled, this.onAdd});
  final bool enabled;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onAdd : null,
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          gradient: enabled ? AppColors.brandGradient : null,
          color: enabled ? null : AppColors.border,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 18),
      ),
    );
  }
}
