import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/api_client.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'providers/device_provider.dart';
import 'providers/order_provider.dart';
import 'providers/service_provider.dart';
import 'providers/theme_provider.dart';
import 'repositories/product_repository.dart';
import 'repositories/device_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // Single API client shared by all repositories (dependency injection).
  final apiClient = ApiClient();
  final productRepo = ProductRepository(apiClient);
  final deviceRepo = DeviceRepository(apiClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ChangeNotifierProvider(create: (_) => AuthProvider(prefs)),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider(productRepo)),
        ChangeNotifierProvider(create: (_) => DeviceProvider(deviceRepo)),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ServiceProvider(productRepo)),
      ],
      child: const SmartSolutionsApp(),
    ),
  );
}
