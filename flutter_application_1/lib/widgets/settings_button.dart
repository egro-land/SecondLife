import 'package:flutter/material.dart';

/// Декоративная кнопка настроек — золотое кольцо с шестерёнкой внутри
/// и ромбиками-акцентами по сторонам (в стиле медальона с обложки книги),
/// подпись "Настройки" снизу.
class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
    required this.onTap,
    this.size = 52,
    this.goldColor = const Color(0xFFE8C878),
  });

  final VoidCallback onTap;
  final double size;
  final Color goldColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size + 16, // запас под ромбики по бокам
            height: size + 16,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Внешнее тонкое кольцо
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.28),
                    border: Border.all(color: goldColor, width: 1.4),
                  ),
                ),

                // Внутреннее кольцо (двойная рамка, как на медальоне)
                Container(
                  width: size - 10,
                  height: size - 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: goldColor.withOpacity(0.6),
                      width: 0.8,
                    ),
                  ),
                ),

                // Ромбики по 4 сторонам
                ..._buildDiamonds(size, goldColor),

                // Шестерёнка
                Icon(
                  Icons.settings_rounded,
                  color: Colors.white,
                  size: size * 0.5,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Настройки',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDiamonds(double size, Color color) {
    final diamond = Transform.rotate(
      angle: 0.785398, // 45°
      child: Container(
        width: 6,
        height: 6,
        color: color,
      ),
    );

    return [
      Align(alignment: const Alignment(0, -1), child: diamond),
      Align(alignment: const Alignment(0, 1), child: diamond),
      Align(alignment: const Alignment(-1, 0), child: diamond),
      Align(alignment: const Alignment(1, 0), child: diamond),
    ];
  }
}
