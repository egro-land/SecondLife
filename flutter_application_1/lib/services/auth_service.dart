 import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';

/// Пользователь приложения.
class AppUser {
  AppUser({required this.email});
  final String email;
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Централизованный сервис авторизации и хранения прогресса игрока.
///
/// Теперь реально обращается к бэкенду (FastAPI + PostgreSQL) через
/// [ApiClient]. Локально хранится только JWT-токен и почта — этого
/// достаточно, чтобы понимать, залогинен ли пользователь, не спрашивая
/// сервер каждый раз.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const _kTokenKey = 'auth_token';
  static const _kEmailKey = 'auth_email';

  String? _cachedToken;

  Future<String?> get _token async {
    if (_cachedToken != null) return _cachedToken;
    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(_kTokenKey);
    return _cachedToken;
  }

  // --- Авторизация -------------------------------------------------------

  Future<AppUser?> get currentUser async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_kEmailKey);
    final token = prefs.getString(_kTokenKey);
    if (email == null || token == null) return null;
    return AppUser(email: email);
  }

  Future<bool> get isLoggedIn async => (await currentUser) != null;

  Future<AppUser> register({
    required String email,
    required String password,
  }) async {
    try {
      final result = await ApiClient.instance.post('/auth/register', {
        'email': email.trim().toLowerCase(),
        'password': password,
      });
      return _saveSession(email, result['access_token'] as String);
    } on ApiException catch (e) {
      throw AuthException(e.message);
    }
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await ApiClient.instance.post('/auth/login', {
        'email': email.trim().toLowerCase(),
        'password': password,
      });
      return _saveSession(email, result['access_token'] as String);
    } on ApiException catch (e) {
      throw AuthException(e.message);
    }
  }

  Future<AppUser> _saveSession(String email, String token) async {
    final normalizedEmail = email.trim().toLowerCase();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTokenKey, token);
    await prefs.setString(_kEmailKey, normalizedEmail);
    _cachedToken = token;
    return AppUser(email: normalizedEmail);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kTokenKey);
    await prefs.remove(_kEmailKey);
    _cachedToken = null;
  }

  // --- Прогресс игры -------------------------------------------------------

  /// Сохраняет прогресс на сервере. Специально "проглатывает" ошибки
  /// сети — если интернет/сервер моргнули на секунду, это не должно
  /// ронять экран во время листания сцены; следующий тап попробует
  /// сохранить снова.
  Future<void> saveProgress(Map<String, dynamic> data) async {
    final token = await _token;
    if (token == null) return;
    try {
      await ApiClient.instance.put('/progress', data, token: token);
    } catch (_) {
      // намеренно игнорируем — см. комментарий выше
    }
  }

  Future<Map<String, dynamic>?> loadProgress() async {
    final token = await _token;
    if (token == null) return null;
    try {
      return await ApiClient.instance.get('/progress', token: token);
    } catch (_) {
      return null;
    }
  }

  // --- Профиль персонажа -----------------------------------------------

  Future<void> saveProfile(Map<String, dynamic> data) async {
    final token = await _token;
    if (token == null) return;
    try {
      await ApiClient.instance.put('/profile', data, token: token);
    } catch (_) {
      // намеренно игнорируем — см. комментарий у saveProgress
    }
  }

  Future<Map<String, dynamic>?> loadProfile() async {
    final token = await _token;
    if (token == null) return null;
    try {
      return await ApiClient.instance.get('/profile', token: token);
    } catch (_) {
      return null;
    }
  }
}
