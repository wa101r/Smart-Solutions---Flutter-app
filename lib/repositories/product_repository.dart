import '../core/api_client.dart';
import '../models/product.dart';
import '../models/service_request.dart';

/// Repository pattern: the UI/providers depend on this, not on the API client.
/// This makes it trivial to swap the data source or mock it in tests.
class ProductRepository {
  ProductRepository(this._api);
  final ApiClient _api;

  Future<List<Product>> fetchProducts() async {
    try {
      final data = await _api.getJson('/products');
      return (data as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    } on ApiException {
      return _mockProducts;
    }
  }

  /// Reviews for a given product (mock).
  Future<List<Review>> fetchReviews(String productId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const [
      Review(
          author: 'Somchai T.',
          rating: 5,
          comment: 'ติดตั้งให้ถึงออฟฟิศ บริการดีมาก เครื่องเร็วใช้ง่าย',
          daysAgo: 3),
      Review(
          author: 'Nattaya P.',
          rating: 4,
          comment: 'คุ้มราคา ประหยัดหมึก แต่คู่มือภาษาไทยน้อยไปนิด',
          daysAgo: 12),
      Review(
          author: 'IT Dept, ABC Co.',
          rating: 5,
          comment: 'ซื้อมา 5 เครื่อง เสถียรดี มีทีม service ตามดูแลตลอด',
          daysAgo: 28),
    ];
  }

  Future<void> submitServiceRequest(ServiceRequest request) async {
    try {
      await _api.postJson('/service-requests', request.toJson());
    } on ApiException {
      await Future<void>.delayed(const Duration(milliseconds: 600));
    }
  }

  static final List<Product> _mockProducts = [
    const Product(
      id: 'p1',
      name: 'SHARP MX-3071 Color Copier',
      brand: 'SHARP',
      sku: 'SHP-MX3071',
      category: 'Copiers',
      price: 89000,
      stockCount: 8,
      rating: 4.8,
      reviewsCount: 124,
      warrantyMonths: 36,
      description:
          'A3 colour multifunction copier, 30 ppm, with secure print and '
          'cloud connectivity for the modern office.',
      imageUrl: '',
      specs: {
        'Type': 'A3 Colour MFP',
        'Speed': '30 ppm',
        'Resolution': '1200 x 1200 dpi',
        'Connectivity': 'Wi-Fi, LAN, USB, Cloud',
        'Paper capacity': '1,200 sheets',
        'Duplex': 'Automatic',
      },
    ),
    const Product(
      id: 'p2',
      name: 'KYOCERA ECOSYS P3155dn',
      brand: 'KYOCERA',
      sku: 'KYO-P3155',
      category: 'Printers',
      price: 24500,
      stockCount: 21,
      rating: 4.6,
      reviewsCount: 88,
      warrantyMonths: 24,
      description: 'Energy-efficient mono laser printer with long-life drum.',
      imageUrl: '',
      specs: {
        'Type': 'Mono Laser',
        'Speed': '55 ppm',
        'Resolution': '1200 dpi',
        'Connectivity': 'LAN, USB',
        'Monthly duty': '275,000 pages',
      },
    ),
    const Product(
      id: 'p3',
      name: 'Sigfox 0G IoT Sensor Kit',
      brand: 'Things on Net',
      sku: 'TON-SGFX-01',
      category: 'IoT',
      price: 5900,
      stockCount: 47,
      rating: 4.7,
      reviewsCount: 36,
      warrantyMonths: 12,
      description:
          'Low-power Sigfox sensor for smart-building monitoring on Thailand\'s '
          '0G network.',
      imageUrl: '',
      specs: {
        'Network': 'Sigfox 0G',
        'Battery life': 'Up to 5 years',
        'Sensors': 'Temp, Humidity, Door',
        'Range': 'Up to 10 km',
        'IP rating': 'IP67',
      },
    ),
    const Product(
      id: 'p4',
      name: 'PANASONIC PT-VMZ51 Projector',
      brand: 'PANASONIC',
      sku: 'PAN-VMZ51',
      category: 'Projectors',
      price: 41900,
      stockCount: 5,
      rating: 4.5,
      reviewsCount: 52,
      warrantyMonths: 24,
      description: '5200 lumens laser projector for meeting rooms.',
      imageUrl: '',
      specs: {
        'Brightness': '5,200 lumens',
        'Resolution': 'WUXGA',
        'Light source': 'Laser (20,000 hrs)',
        'Throw': '1.09–1.77:1',
        'Connectivity': 'HDMI, LAN, USB',
      },
    ),
    const Product(
      id: 'p5',
      name: 'Smart Home Gateway Hub',
      brand: 'SmartHome',
      sku: 'SS-HUB-2',
      category: 'IoT',
      price: 3200,
      stockCount: 0,
      rating: 4.3,
      reviewsCount: 19,
      warrantyMonths: 12,
      description: 'Central hub to control lights, locks, and sensors.',
      imageUrl: '',
      inStock: false,
      specs: {
        'Protocols': 'Zigbee, Wi-Fi, BLE',
        'Devices': 'Up to 128',
        'Power': 'USB-C 5V',
      },
    ),
    const Product(
      id: 'p6',
      name: 'Electronic Cash Register ER-A410',
      brand: 'SHARP',
      sku: 'SHP-ERA410',
      category: 'POS',
      price: 12800,
      stockCount: 14,
      rating: 4.4,
      reviewsCount: 41,
      warrantyMonths: 12,
      description: 'Reliable cash register for retail and F&B businesses.',
      imageUrl: '',
      specs: {
        'Departments': '99',
        'PLU': '7,000',
        'Drawer': '5 notes / 8 coins',
        'Display': 'Dual LED',
      },
    ),
    const Product(
      id: 'p7',
      name: 'KYOCERA TASKalfa 2554ci',
      brand: 'KYOCERA',
      sku: 'KYO-2554CI',
      category: 'Copiers',
      price: 76500,
      stockCount: 6,
      rating: 4.6,
      reviewsCount: 33,
      warrantyMonths: 36,
      description: 'A3 colour MFP with 25 ppm and large touchscreen.',
      imageUrl: '',
      specs: {
        'Type': 'A3 Colour MFP',
        'Speed': '25 ppm',
        'Touchscreen': '10.1 inch',
        'Connectivity': 'Wi-Fi, LAN, USB',
      },
    ),
    const Product(
      id: 'p8',
      name: 'Smart Door Lock Pro',
      brand: 'SmartHome',
      sku: 'SS-LOCK-P',
      category: 'IoT',
      price: 6900,
      stockCount: 18,
      rating: 4.5,
      reviewsCount: 27,
      warrantyMonths: 24,
      description: 'Fingerprint + PIN + app smart lock for office doors.',
      imageUrl: '',
      specs: {
        'Unlock': 'Fingerprint, PIN, App, Card',
        'Battery': '8 months',
        'Material': 'Zinc alloy',
      },
    ),
  ];
}
