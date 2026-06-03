import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Minimal email/password auth for the demo. A real app would call an
/// authentication endpoint and store a JWT; here we persist a flag + email.
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._prefs) {
    _email = _prefs.getString(_emailKey);
  }

  static const _emailKey = 'auth_email';
  final SharedPreferences _prefs;
  String? _email;
  bool _loading = false;

  bool get isLoggedIn => _email != null;
  String? get email => _email;
  bool get loading => _loading;

  /// Derived profile info for the Account screen.
  String get displayName {
    if (_email == null) return 'Guest';
    final handle = _email!.split('@').first.replaceAll(RegExp(r'[._]'), ' ');
    return handle.isEmpty
        ? 'User'
        : handle[0].toUpperCase() + handle.substring(1);
  }

  String get role => 'Account Admin';
  String get company => 'Smart Solutions Co., Ltd.';
  String get initials {
    final n = displayName.trim();
    if (n.isEmpty) return 'U';
    final parts = n.split(' ');
    return parts.length > 1
        ? (parts[0][0] + parts[1][0]).toUpperCase()
        : n.substring(0, 1).toUpperCase();
  }

  Future<String?> login(String email, String password) async {
    _loading = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 700));
    _loading = false;

    if (!email.contains('@') || password.length < 4) {
      notifyListeners();
      return 'Invalid email or password (min 4 chars).';
    }
    _email = email;
    await _prefs.setString(_emailKey, email);
    notifyListeners();
    return null; // success
  }

  Future<void> logout() async {
    _email = null;
    await _prefs.remove(_emailKey);
    notifyListeners();
  }
}
