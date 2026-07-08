import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'audio/background_music_service.dart';
import 'screens/book_opening_video_screen.dart';
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
  late VideoPlayerController _bookVideoController;
  bool _controllerConsumed = false;

  @override
  void initState() {
    super.initState();
    // Запускаем фоновую музыку главного экрана.
    // Файл должен лежать в assets/audio/main_theme.mp3
    // (см. инструкцию по подключению ниже).
    BackgroundMusicService.instance.playLoop('audio/main_theme.mp3');

    _prepareBookVideo();
  }

  void _prepareBookVideo() {
    // Начинаем грузить видео открытия книги ЗАРАНЕЕ, ещё до тапа —
    // чтобы к моменту перехода оно уже было готово и не мелькал чёрный
    // экран, пока видео буферизуется.
    _bookVideoController =
        VideoPlayerController.asset('assets/video/book_open.mp4')
          ..initialize();
    _controllerConsumed = false;
  }

  void _onBookTap() {
    // Если человек уже открывал книгу раньше — старый контроллер уничтожен
    // видео-экраном при выходе, нужен новый
    if (_controllerConsumed) {
      _prepareBookVideo();
    }
    _controllerConsumed = true;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookOpeningVideoScreen(
          controller: _bookVideoController,
          fallback: _buildMainScreenContent(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Если контроллер ещё не "передан" на видео-экран (человек так и не
    // тапнул по книге) — его нужно закрыть здесь, иначе будет утечка
    if (!_controllerConsumed) {
      _bookVideoController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildMainScreenContent(),
    );
  }

  /// Вынесено отдельно, чтобы этот же набор виджетов можно было
  /// использовать как fallback на видео-экране (для незаметного перехода)
  Widget _buildMainScreenContent() {
    return Stack(
        children: [
          // Фон
          SizedBox.expand(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Картинка по центру чуть правее — тап открывает видео
          Align(
            alignment: const Alignment(0.3, 0),
            child: GestureDetector(
              onTap: _onBookTap,
              child: Image.asset(
                'assets/images/logo.png',
                width: 400,
              ),
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
      );
  }
}
