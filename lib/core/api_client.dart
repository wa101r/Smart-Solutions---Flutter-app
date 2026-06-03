import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// Thin wrapper around `http` so repositories don't deal with URLs/headers.
///
/// In a real project `baseUrl` points at your backend (Laravel/REST API).
/// For the demo we fall back to bundled mock data when the network is off,
/// so the app always renders during an interview demo.
class ApiClient {
  ApiClient({this.baseUrl = 'https://api.smartsolutions.example'});

  final String baseUrl;
  final http.Client _client = http.Client();

  Future<dynamic> getJson(String path) async {
    try {
      final res = await _client
          .get(Uri.parse('$baseUrl$path'))
          .timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
      throw ApiException('GET $path failed (${res.statusCode})');
    } on ApiException {
      rethrow;
    } catch (e) {
      // Network/DNS/timeout errors (incl. web ClientException) -> ApiException
      // so repositories can fall back to mock data.
      throw ApiException('GET $path failed: $e');
    }
  }

  Future<dynamic> postJson(String path, Map<String, dynamic> body) async {
    try {
      final res = await _client
          .post(
            Uri.parse('$baseUrl$path'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 5));
      if (res.statusCode == 200 || res.statusCode == 201) {
        return jsonDecode(res.body);
      }
      throw ApiException('POST $path failed (${res.statusCode})');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('POST $path failed: $e');
    }
  }

  void dispose() => _client.close();
}

class ApiException implements Exception {
  ApiException(this.message);
  final String message;
  @override
  String toString() => message;
}
