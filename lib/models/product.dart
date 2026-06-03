/// A product the company sells: copiers, projectors, IoT sensors, etc.
class Product {
  const Product({
    required this.id,
    required this.name,
    this.brand = '',
    this.sku = '',
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
    this.inStock = true,
    this.stockCount = 0,
    this.rating = 0,
    this.reviewsCount = 0,
    this.warrantyMonths = 12,
    this.specs = const {},
  });

  final String id;
  final String name;
  final String brand;
  final String sku;
  final String category;
  final double price;
  final String description;
  final String imageUrl;
  final bool inStock;
  final int stockCount;
  final double rating; // 0..5
  final int reviewsCount;
  final int warrantyMonths;
  final Map<String, String> specs;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'].toString(),
        name: json['name'] as String,
        brand: json['brand'] as String? ?? '',
        sku: json['sku'] as String? ?? '',
        category: json['category'] as String,
        price: (json['price'] as num).toDouble(),
        description: json['description'] as String? ?? '',
        imageUrl: json['imageUrl'] as String? ?? '',
        inStock: json['inStock'] as bool? ?? true,
        stockCount: json['stockCount'] as int? ?? 0,
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        reviewsCount: json['reviewsCount'] as int? ?? 0,
        warrantyMonths: json['warrantyMonths'] as int? ?? 12,
        specs: (json['specs'] as Map?)?.map(
                (k, v) => MapEntry(k.toString(), v.toString())) ??
            const {},
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'brand': brand,
        'sku': sku,
        'category': category,
        'price': price,
        'description': description,
        'imageUrl': imageUrl,
        'inStock': inStock,
        'stockCount': stockCount,
        'rating': rating,
        'reviewsCount': reviewsCount,
        'warrantyMonths': warrantyMonths,
        'specs': specs,
      };
}

/// A customer review on a product.
class Review {
  const Review({
    required this.author,
    required this.rating,
    required this.comment,
    required this.daysAgo,
  });

  final String author;
  final double rating;
  final String comment;
  final int daysAgo;
}
