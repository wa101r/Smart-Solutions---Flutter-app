import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider(this._prefs) {
    _dark = _prefs.getBool(_key) ?? false;
  }

  static const _key = 'dark_mode';
  final SharedPreferences _prefs;
  bool _dark = false;

  ThemeMode get themeMode => _dark ? ThemeMode.dark : ThemeMode.light;
  bool get isDark => _dark;

  void toggle() {
    _dark = !_dark;
    _prefs.setBool(_key, _dark);
    notifyListeners();
  }
}
