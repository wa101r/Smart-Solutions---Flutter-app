// Smoke test: the app boots and shows the login screen.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smart_solutions/app.dart';
import 'package:smart_solutions/providers/auth_provider.dart';
import 'package:smart_solutions/providers/cart_provider.dart';
import 'package:smart_solutions/providers/product_provider.dart';
import 'package:smart_solutions/providers/device_provider.dart';
import 'package:smart_solutions/providers/theme_provider.dart';
import 'package:smart_solutions/repositories/product_repository.dart';
import 'package:smart_solutions/repositories/device_repository.dart';
import 'package:smart_solutions/core/api_client.dart';

void main() {
  testWidgets('App boots to the login screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final api = ApiClient();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
          ChangeNotifierProvider(create: (_) => AuthProvider(prefs)),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(
              create: (_) => ProductProvider(ProductRepository(api))),
          ChangeNotifierProvider(
              create: (_) => DeviceProvider(DeviceRepository(api))),
        ],
        child: const SmartSolutionsApp(),
      ),
    );

    // Not logged in -> login screen shows the Sign In button.
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Smart Solutions'), findsOneWidget);
  });
}
