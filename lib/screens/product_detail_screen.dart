import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../core/design_tokens.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/gradient_button.dart';
import '../widgets/rating_stars.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});
  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _qty = 1;
  final _baht =
      NumberFormat.currency(locale: 'th_TH', symbol: '฿', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final scheme = Theme.of(context).colorScheme;
    final provider = context.read<ProductProvider>();
    final related = provider.relatedTo(p);

    return Scaffold(
      appBar: AppBar(title: Text(p.category)),
      body: ListView(
        children: [
          // Hero image area
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.indigo.withValues(alpha: 0.12),
                  AppColors.violet.withValues(alpha: 0.12),
                ],
              ),
            ),
            child: Icon(Icons.devices, size: 96, color: scheme.primary),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${p.brand} · ${p.sku}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.textMuted)),
                const SizedBox(height: 4),
                Text(p.name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    RatingStars(rating: p.rating),
                    const SizedBox(width: 6),
                    Text('${p.rating}  (${p.reviewsCount} reviews)',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 12),
                Text(_baht.format(p.price),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.indigo, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _Pill(
                      icon: p.inStock ? Icons.check_circle : Icons.cancel,
                      label: p.inStock ? '${p.stockCount} in stock' : 'Out of stock',
                      color: p.inStock ? AppColors.success : AppColors.danger,
                    ),
                    const SizedBox(width: 8),
                    _Pill(
                      icon: Icons.verified_user_outlined,
                      label: '${p.warrantyMonths}-mo warranty',
                      color: AppColors.indigo,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Description',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(p.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(height: 1.5)),

                // Specs table
                if (p.specs.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text('Specifications',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  _SpecsTable(specs: p.specs),
                ],

                // Reviews
                const SizedBox(height: AppSpacing.lg),
                Text('Reviews',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                FutureBuilder<List<Review>>(
                  future: provider.reviewsFor(p.id),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final reviews = snap.data ?? [];
                    return Column(
                      children: [for (final r in reviews) _ReviewTile(review: r)],
                    );
                  },
                ),

                // Related
                if (related.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text('Related products',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 96,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: related.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, i) {
                        final r = related[i];
                        return GestureDetector(
                          onTap: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (_) => ProductDetailScreen(product: r)),
                          ),
                          child: Container(
                            width: 180,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.card),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13)),
                                const Spacer(),
                                Text(_baht.format(r.price),
                                    style: const TextStyle(
                                        color: AppColors.indigo,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Quantity selector
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: _qty > 1 ? () => setState(() => _qty--) : null,
                    ),
                    Text('$_qty',
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() => _qty++),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: GradientButton(
                  label: p.inStock ? 'Add to cart' : 'Out of stock',
                  icon: p.inStock ? Icons.add_shopping_cart : null,
                  onPressed: p.inStock
                      ? () {
                          final cart = context.read<CartProvider>();
                          for (var i = 0; i < _qty; i++) {
                            cart.add(p);
                          }
                          Navigator.of(context).pop();
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _SpecsTable extends StatelessWidget {
  const _SpecsTable({required this.specs});
  final Map<String, String> specs;

  @override
  Widget build(BuildContext context) {
    final entries = specs.entries.toList();
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: i == entries.length - 1
                        ? Colors.transparent
                        : AppColors.border,
                  ),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 130,
                    child: Text(entries[i].key,
                        style: const TextStyle(color: AppColors.textMuted)),
                  ),
                  Expanded(
                    child: Text(entries[i].value,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});
  final Review review;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.indigo.withValues(alpha: 0.12),
                child: Text(review.author[0],
                    style: const TextStyle(
                        color: AppColors.indigo,
                        fontWeight: FontWeight.w700,
                        fontSize: 12)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(review.author,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              Text('${review.daysAgo}d ago',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 6),
          RatingStars(rating: review.rating, size: 14),
          const SizedBox(height: 6),
          Text(review.comment, style: const TextStyle(height: 1.4)),
        ],
      ),
    );
  }
}
