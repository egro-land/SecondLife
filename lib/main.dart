import 'package:flutter/material.dart';
import 'audio/background_music_service.dart';
import 'screens/settings_screen.dart';
import 'widgets/floating_widget.dart';
import 'widgets/settings_button.dart';

void main() {
  runApp(const SecondLifeApp());
}

class SecondLifeApp extends StatelessWidget {
  const SecondLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Вторая жизнь',
      home: const BlackScreen(),
    );
  }
}

class BlackScreen extends StatefulWidget {
  const BlackScreen({super.key});

  @override
  State<BlackScreen> createState() => _BlackScreenState();
}

class _BlackScreenState extends State<BlackScreen> {
  @override
  void initState() {
    super.initState();
    // Запускаем фоновую музыку главного экрана.
    // Файл должен лежать в assets/audio/main_theme.mp3
    // (см. инструкцию по подключению ниже).
    BackgroundMusicService.instance.playLoop('audio/main_theme.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Фон
          SizedBox.expand(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Картинка по центру чуть правее
          Align(
            alignment: const Alignment(0.3, 0),
            child: Image.asset(
              'assets/images/logo.png',
              width: 400,
            ),
          ),

          // Персонаж — естественно парит, как Паймон в Genshin
          Align(
            alignment: const Alignment(-1, 0.1),
            child: FloatingWidget(
              amplitude: 12,
              duration: const Duration(seconds: 3),
              child: Image.asset(
                'assets/images/character2.png',
                height: 250,
              ),
            ),
          ),

          // Кнопка настроек — сверху справа
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 12, top: 8),
                child: SettingsButton(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
