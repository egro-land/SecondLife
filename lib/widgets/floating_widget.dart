import 'dart:math';
import 'package:flutter/material.dart';

/// Оборачивает [child] и заставляет его естественно парить —
/// плавно покачиваться вверх-вниз с лёгким наклоном,
/// как Паймон в Genshin Impact.
///
/// Пример:
/// ```dart
/// FloatingWidget(
///   child: Image.asset('assets/images/character2.png', height: 250),
/// )
/// ```
class FloatingWidget extends StatefulWidget {
  const FloatingWidget({
    super.key,
    required this.child,
    this.amplitude = 12,
    this.duration = const Duration(seconds: 3),
    this.rotationAmplitude = 0.03,
  });

  /// Что анимируем (обычно Image.asset с персонажем)
  final Widget child;

  /// На сколько пикселей персонаж уходит вверх/вниз
  final double amplitude;

  /// Длительность одного полного цикла (вверх-вниз)
  final Duration duration;

  /// Амплитуда лёгкого покачивания в радианах (0 — выключить наклон)
  final double rotationAmplitude;

  @override
  State<FloatingWidget> createState() => _FloatingWidgetState();
}

class _FloatingWidgetState extends State<FloatingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Синусоида даёт плавное, естественное движение без рывков
        // на верхней/нижней точке (в отличие от reverse-Tween).
        final t = _controller.value * 2 * pi;
        final dy = sin(t) * widget.amplitude;
        final angle = sin(t) * widget.rotationAmplitude;

        return Transform.translate(
          offset: Offset(0, dy),
          child: Transform.rotate(
            angle: angle,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
