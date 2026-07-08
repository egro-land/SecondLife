import 'package:flutter/material.dart';
import 'screens/settings_screen.dart';

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

class BlackScreen extends StatelessWidget {
  const BlackScreen({super.key});

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

          // Персонаж
          Align(
            alignment: const Alignment(-1, 0.1),
            child: Image.asset(
              'assets/images/character2.png',
              height: 250,
            ),
          ),

          // Кнопка настроек — сверху слева
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 4),
                child: IconButton(
                  icon: const Icon(Icons.settings_rounded),
                  color: Colors.white,
                  iconSize: 30,
                  tooltip: 'Настройки',
                  onPressed: () {
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
