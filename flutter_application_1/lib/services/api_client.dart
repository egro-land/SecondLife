import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';

class ApiException implements Exception {
  ApiException(this.statusCode, this.message);
  final int statusCode;
  final String message;
  @override
  String toString() => message;
}

/// Тонкая обёртка над http-запросами к бэкенду: собирает адрес,
/// подставляет заголовок Authorization, разбирает JSON-ответ и ошибки
/// в единообразный вид (ApiException с понятным текстом).
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body, {
    String? token,
  }) =>
      _request('POST', path, body: body, token: token);

  Future<Map<String, dynamic>> put(
    String path,
    Map<String, dynamic> body, {
    String? token,
  }) =>
      _request('PUT', path, body: body, token: token);

  Future<Map<String, dynamic>> get(String path, {String? token}) =>
      _request('GET', path, token: token);

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    http.Response response;
    try {
      switch (method) {
        case 'POST':
          response = await http
              .post(uri, headers: headers, body: jsonEncode(body))
              .timeout(const Duration(seconds: 10));
          break;
        case 'PUT':
          response = await http
              .put(uri, headers: headers, body: jsonEncode(body))
              .timeout(const Duration(seconds: 10));
          break;
        default:
          response =
              await http.get(uri, headers: headers).timeout(const Duration(seconds: 10));
      }
    } catch (_) {
      throw ApiException(
        0,
        'Не удалось подключиться к серверу. Проверь, что бэкенд запущен '
        '(docker compose up) и телефон в той же Wi-Fi сети, что и компьютер.',
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    var message = 'Ошибка сервера (${response.statusCode})';
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['detail'] != null) {
        final detail = decoded['detail'];
        message = detail is String ? detail : 'Некорректные данные';
      }
    } catch (_) {
      // Ответ не в JSON — оставляем общее сообщение выше.
    }

    throw ApiException(response.statusCode, message);
  }
}
