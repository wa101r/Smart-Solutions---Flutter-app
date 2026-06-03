import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/login_screen.dart';
import 'screens/root_nav.dart';

class SmartSolutionsApp extends StatelessWidget {
  const SmartSolutionsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final auth = context.watch<AuthProvider>();

    return MaterialApp(
      title: 'Smart Solutions',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.themeMode,
      // Simple auth gate: show login until the user is signed in.
      home: auth.isLoggedIn ? const RootNav() : const LoginScreen(),
    );
  }
}
