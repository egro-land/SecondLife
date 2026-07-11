import 'package:flutter/material.dart';

import '../main.dart';
import '../models/game_progress.dart';
import '../services/auth_service.dart';
import 'auth_screen.dart';

/// Первый экран, который видит игрок при запуске приложения.
///
/// Решает, что показать:
/// - пока идёт проверка — простой лоадер;
/// - если пользователь не залогинен — экран входа/регистрации;
/// - если залогинен — ВСЕГДА открывает главное меню (BlackScreen).
///   Сохранённый прогресс (пролог/регистрация персонажа) при этом не
///   теряется — он передаётся в BlackScreen и используется только
///   тогда, когда игрок сам нажимает на книжку, чтобы открыть её
///   ровно с того места, где он остановился в прошлый раз (см.
///   BlackScreen._onBookTap в lib/main.dart).
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

enum _Status { loading, needsAuth, ready }

class _AuthGateState extends State<AuthGate> {
  _Status _status = _Status.loading;
  GameProgress? _progress;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final loggedIn = await AuthService.instance.isLoggedIn;
    if (!loggedIn) {
      if (mounted) setState(() => _status = _Status.needsAuth);
      return;
    }
    await _loadProgressAndReady();
  }

  Future<void> _loadProgressAndReady() async {
    final raw = await AuthService.instance.loadProgress();
    if (!mounted) return;
    setState(() {
      _progress = raw != null ? GameProgress.fromJson(raw) : null;
      _status = _Status.ready;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case _Status.loading:
        return const _LoadingScreen();
      case _Status.needsAuth:
        return AuthScreen(onAuthenticated: _loadProgressAndReady);
      case _Status.ready:
        // Главное меню показывается всегда. Прогресс (если есть)
        // просто передаётся дальше — BlackScreen сам решит, куда вести
        // игрока, когда тот нажмёт на книжку.
        return BlackScreen(progress: _progress);
    }
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0A1030),
      body: Center(
        child: CircularProgressIndicator(color: Color(0xFFE8C878)),
      ),
    );
  }
}
