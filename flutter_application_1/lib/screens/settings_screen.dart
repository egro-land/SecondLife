import 'package:flutter/material.dart';
import '../settings/app_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppSettings.instance;

    return Scaffold(
      body: Stack(
        children: [
          // Тот же фон, что и на стартовом экране, для цельного ощущения
          SizedBox.expand(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Затемнение поверх фона, чтобы текст и ползунки читались
          Container(color: Colors.black.withOpacity(0.45)),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Кнопка "назад" + заголовок
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        iconSize: 28,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Настройки',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _VolumeSlider(
                        icon: Icons.music_note_rounded,
                        label: 'Громкость музыки',
                        valueListenable: settings.musicVolume,
                        onChanged: (v) => settings.musicVolume.value = v,
                      ),
                      const SizedBox(height: 32),
                      _VolumeSlider(
                        icon: Icons.record_voice_over_rounded,
                        label: 'Громкость голосов персонажей',
                        valueListenable: settings.voiceVolume,
                        onChanged: (v) => settings.voiceVolume.value = v,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VolumeSlider extends StatelessWidget {
  const _VolumeSlider({
    required this.icon,
    required this.label,
    required this.valueListenable,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final ValueNotifier<double> valueListenable;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFFE8C878), size: 22),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        ValueListenableBuilder<double>(
          valueListenable: valueListenable,
          builder: (context, value, _) {
            return Row(
              children: [
                const Icon(Icons.volume_mute_rounded,
                    color: Colors.white54, size: 18),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFFE8C878),
                      inactiveTrackColor: Colors.white24,
                      thumbColor: const Color(0xFFE8C878),
                      overlayColor: const Color(0x33E8C878),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: value,
                      min: 0.0,
                      max: 1.0,
                      onChanged: onChanged,
                    ),
                  ),
                ),
                const Icon(Icons.volume_up_rounded,
                    color: Colors.white54, size: 18),
                SizedBox(
                  width: 42,
                  child: Text(
                    '${(value * 100).round()}%',
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
