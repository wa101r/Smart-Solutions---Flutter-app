import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../models/service_request.dart';
import '../repositories/product_repository.dart';

enum LoadState { idle, loading, ready, error }

enum ProductSort { featured, priceLow, priceHigh, rating }

extension ProductSortLabel on ProductSort {
  String get label => switch (this) {
        ProductSort.featured => 'Featured',
        ProductSort.priceLow => 'Price: Low to High',
        ProductSort.priceHigh => 'Price: High to Low',
        ProductSort.rating => 'Top rated',
      };
}

class ProductProvider extends ChangeNotifier {
  ProductProvider(this._repo);
  final ProductRepository _repo;

  LoadState state = LoadState.idle;
  String? error;
  List<Product> _all = [];
  String _query = '';
  String _category = 'All';
  ProductSort _sort = ProductSort.featured;
  bool _inStockOnly = false;

  /// Filtered + sorted view used by the catalog screen.
  List<Product> get products {
    final list = _all.where((p) {
      final matchesCategory = _category == 'All' || p.category == _category;
      final matchesQuery =
          _query.isEmpty || p.name.toLowerCase().contains(_query.toLowerCase());
      final matchesStock = !_inStockOnly || p.inStock;
      return matchesCategory && matchesQuery && matchesStock;
    }).toList();

    switch (_sort) {
      case ProductSort.priceLow:
        list.sort((a, b) => a.price.compareTo(b.price));
      case ProductSort.priceHigh:
        list.sort((a, b) => b.price.compareTo(a.price));
      case ProductSort.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case ProductSort.featured:
        break;
    }
    return list;
  }

  List<String> get categories =>
      ['All', ...{for (final p in _all) p.category}];

  String get category => _category;
  ProductSort get sort => _sort;
  bool get inStockOnly => _inStockOnly;

  void setSort(ProductSort s) {
    _sort = s;
    notifyListeners();
  }

  void toggleInStockOnly() {
    _inStockOnly = !_inStockOnly;
    notifyListeners();
  }

  Future<void> load() async {
    state = LoadState.loading;
    notifyListeners();
    try {
      _all = await _repo.fetchProducts();
      state = LoadState.ready;
    } catch (e) {
      error = e.toString();
      state = LoadState.error;
    }
    notifyListeners();
  }

  void search(String q) {
    _query = q;
    notifyListeners();
  }

  void selectCategory(String c) {
    _category = c;
    notifyListeners();
  }

  Future<void> submitServiceRequest(ServiceRequest request) =>
      _repo.submitServiceRequest(request);

  Future<List<Review>> reviewsFor(String productId) =>
      _repo.fetchReviews(productId);

  /// Other products in the same category (for the "Related" section).
  List<Product> relatedTo(Product product) => _all
      .where((p) => p.category == product.category && p.id != product.id)
      .take(6)
      .toList();
}
