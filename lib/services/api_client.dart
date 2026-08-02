import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';

/// A failure the UI can show to the user without leaking internals.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Thin HTTP wrapper around the Express backend.
///
/// Owns the bearer token for the session. The token currently lives in memory
/// only, so it is dropped when the app is killed — persisting it needs a
/// secure store (`flutter_secure_storage`), which would add a dependency.
class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  final http.Client _http = http.Client();

  String? _token;

  String? get token => _token;
  bool get isAuthenticated => _token != null;

  void setToken(String? token) => _token = token;
  void clearToken() => _token = null;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('${AppConfig.apiBaseUrl}$path').replace(
        queryParameters: (query != null && query.isNotEmpty) ? query : null,
      );

  Future<Map<String, dynamic>> get(String path, {Map<String, String>? query}) =>
      _send(() => _http.get(_uri(path, query), headers: _headers));

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) =>
      _send(() => _http.post(_uri(path), headers: _headers, body: jsonEncode(body)));

  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) =>
      _send(() => _http.put(_uri(path), headers: _headers, body: jsonEncode(body)));

  Future<Map<String, dynamic>> _send(Future<http.Response> Function() request) async {
    http.Response response;

    try {
      response = await request().timeout(AppConfig.requestTimeout);
    } on TimeoutException {
      throw ApiException('The server took too long to respond. Please try again.');
    } catch (_) {
      // SocketException on native, ClientException on web — both mean the host
      // could not be reached. Avoiding dart:io here keeps the web build working.
      throw ApiException(
        'Cannot reach the server. Check that the backend is running and that '
        'API_BASE_URL points at it.',
      );
    }

    Map<String, dynamic> body;
    try {
      final decoded = response.body.isEmpty ? {} : jsonDecode(response.body);
      body = decoded is Map<String, dynamic> ? decoded : {'data': decoded};
    } on FormatException {
      throw ApiException(
        'Unexpected response from the server.',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    throw ApiException(_errorMessage(body, response.statusCode),
        statusCode: response.statusCode);
  }

  /// The backend reports failures either as `{ message }` or, for validation
  /// failures, as `{ errors: [{ msg, path }] }`.
  String _errorMessage(Map<String, dynamic> body, int statusCode) {
    final errors = body['errors'];
    if (errors is List && errors.isNotEmpty) {
      return errors
          .map((e) => e is Map ? (e['msg'] ?? '').toString() : e.toString())
          .where((msg) => msg.isNotEmpty)
          .join('\n');
    }

    final message = body['message'];
    if (message is String && message.isNotEmpty) return message;

    return 'Request failed ($statusCode)';
  }
}
