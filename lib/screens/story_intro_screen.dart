import 'package:flutter/material.dart';

/// Экран начала истории (пролог). Пока заглушка — сюда позже пойдут
/// диалоги, текст сцены с родителями и появление Люми.
class StoryIntroScreen extends StatelessWidget {
  const StoryIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white70),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Пролог начинается здесь…',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
