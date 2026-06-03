import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/skeleton.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  void initState() {
    super.initState();
    // Load once after first frame.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<ProductProvider>().load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final cart = context.watch<CartProvider>();
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: Icon(theme.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: theme.toggle,
          ),
          IconButton(
            icon: Badge(
              isLabelVisible: cart.count > 0,
              label: Text('${cart.count}'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CartScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
      body: switch (provider.state) {
        LoadState.loading || LoadState.idle => const _CatalogSkeleton(),
        LoadState.error => Center(child: Text(provider.error ?? 'Error')),
        LoadState.ready => _CatalogBody(provider: provider),
      },
    );
  }
}

class _CatalogSkeleton extends StatelessWidget {
  const _CatalogSkeleton();
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Expanded(child: Skeleton(radius: 16)),
          SizedBox(height: 8),
          Skeleton(height: 12, width: 120),
          SizedBox(height: 6),
          Skeleton(height: 12, width: 70),
        ],
      ),
    );
  }
}

class _CatalogBody extends StatelessWidget {
  const _CatalogBody({required this.provider});
  final ProductProvider provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: TextField(
            onChanged: provider.search,
            decoration: const InputDecoration(
              hintText: 'Search products…',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              for (final c in provider.categories)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(c),
                    selected: provider.category == c,
                    onSelected: (_) => provider.selectCategory(c),
                  ),
                ),
            ],
          ),
        ),
        // Sort + filter bar
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Row(
            children: [
              Text('${provider.products.length} items',
                  style: Theme.of(context).textTheme.bodySmall),
              const Spacer(),
              FilterChip(
                label: const Text('In stock'),
                selected: provider.inStockOnly,
                onSelected: (_) => provider.toggleInStockOnly(),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<ProductSort>(
                initialValue: provider.sort,
                onSelected: provider.setSort,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sort, size: 18),
                    const SizedBox(width: 4),
                    Text(provider.sort.label,
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
                itemBuilder: (context) => [
                  for (final s in ProductSort.values)
                    PopupMenuItem(value: s, child: Text(s.label)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              childAspectRatio: 0.72,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: provider.products.length,
            itemBuilder: (context, i) {
              final p = provider.products[i];
              return ProductCard(
                product: p,
                onAdd: () {
                  context.read<CartProvider>().add(p);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${p.name} added'),
                      duration: const Duration(milliseconds: 800),
                    ),
                  );
                },
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(product: p),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
