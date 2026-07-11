import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'audio/background_music_service.dart';
import 'models/game_progress.dart';
import 'screens/auth_gate.dart';
import 'screens/book_opening_video_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/floating_widget.dart';
import 'widgets/settings_button.dart';

/// Общий на всё приложение наблюдатель за переходами между экранами.
/// Нужен, чтобы BlackScreen узнавал, когда на него вернулись
/// (например, после просмотра видео) — и мог возобновить музыку и
/// подготовить свежий видео-контроллер для следующего открытия книги.
final RouteObserver<ModalRoute<void>> appRouteObserver =
    RouteObserver<ModalRoute<void>>();

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
      navigatorObservers: [appRouteObserver],
      // Раньше здесь сразу открывался BlackScreen (главное меню).
      // Теперь первым делом проверяется, залогинен ли игрок, и если
      // да — восстанавливается прогресс (пролог/регистрация/меню).
      // См. lib/screens/auth_gate.dart.
      home: const AuthGate(),
    );
  }
}

class BlackScreen extends StatefulWidget {
  const BlackScreen({super.key, this.progress});

  /// Сохранённый прогресс игрока (незаконченный пролог или регистрация
  /// персонажа), если он есть. Используется только в момент нажатия на
  /// книжку — чтобы открыть её сразу с того места, где игрок
  /// остановился в прошлый раз, а не с самого начала.
  final GameProgress? progress;

  @override
  State<BlackScreen> createState() => _BlackScreenState();
}

class _BlackScreenState extends State<BlackScreen> with RouteAware {
  late VideoPlayerController _bookVideoController;

  // true, пока текущий _bookVideoController ещё "свежий" и не был
  // передан на видео-экран (и, соответственно, не уничтожен им)
  bool _controllerIsFresh = true;

  @override
  void initState() {
    super.initState();
    BackgroundMusicService.instance.playLoop('audio/main_theme.mp3');
    _prepareBookVideo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      appRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    if (_controllerIsFresh) {
      _bookVideoController.dispose();
    }
    super.dispose();
  }

  /// Срабатывает автоматически каждый раз, когда мы возвращаемся на этот
  /// экран (закрыли видео/пролог, вышли из настроек — что угодно поверх).
  @override
  void didPopNext() {
    // Музыка должна играть только в главном меню
    BackgroundMusicService.instance.resume();
    BackgroundMusicService.instance.ensurePlaying();

    // Если контроллер уже был "использован" (то есть его успел закрыть
    // видео-экран) — готовим новый заранее, чтобы следующий тап по книге
    // сработал сразу, без гонки состояний и зависаний.
    if (!_controllerIsFresh) {
      _prepareBookVideo();
    }
  }

  void _prepareBookVideo() {
    _bookVideoController =
        VideoPlayerController.asset('assets/video/book_open.mp4')
          ..initialize();
    _controllerIsFresh = true;
  }

  void _onBookTap() {
    _controllerIsFresh = false; // отдаём контроллер видео-экрану

    final progress = widget.progress;
    final isResumingAwakening = progress?.stage == GameStage.awakening;
    final isResumingRegistration = progress?.stage == GameStage.registration;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookOpeningVideoScreen(
          controller: _bookVideoController,
          fallback: _buildMainScreenContent(),
          // Если игрок в прошлый раз не досмотрел пролог — открываем
          // сцену сразу на нужном такте/странице вместо самого начала.
          initialBeatIndex: isResumingAwakening ? progress!.beatIndex : null,
          initialPageIndex: isResumingAwakening ? progress!.pageIndex : 0,
          // Если пролог уже пройден, но регистрация персонажа не
          // завершена — сразу после видео открываем именно её.
          startAtRegistration: isResumingRegistration,
        ),
      ),
    );
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        // Книжка и персонаж теперь лежат в общем полноэкранном Stack
        // (а не внутри Expanded), поэтому их размер больше ничем не
        // обрезается — можно смело крутить множители ниже.
        final bookWidth = screenWidth * 0.5;
        final characterHeight = screenWidth * 0.85;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox.expand(
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ),

            // Книжка — вынесена из Expanded, размер задаётся напрямую
            Align(
              alignment: const Alignment(0.5, 0.05),
              child: GestureDetector(
                onTap: _onBookTap,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: bookWidth,
                ),
              ),
            ),

            // Персонаж — вынесен из Expanded, размер задаётся напрямую.
            // Стоит после книжки в списке детей Stack, поэтому рисуется
            // поверх неё.
            Align(
              alignment: const Alignment(-1, 0.13),
              child: FloatingWidget(
                amplitude: 12,
                duration: const Duration(seconds: 3),
                child: Image.asset(
                  'assets/images/character2.png',
                  height: characterHeight,
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 78),
                  const _TitleWithDividers(
                    text: 'Давай проживём\nещё одну жизнь',
                  ),
                ],
              ),
            ),

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
      },
    );
  }
}

/// Заголовок с тонкими золотыми разделителями и ромбиком по центру,
/// в стиле медальона с обложки книги.
class _TitleWithDividers extends StatelessWidget {
  const _TitleWithDividers({required this.text});

  final String text;

  static const _gold = Color(0xFFE8C878);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          _divider(),
          const SizedBox(height: 14),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1B2A6B),
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.35,
              shadows: [
                Shadow(color: Colors.white, blurRadius: 6),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _divider(),
        ],
      ),
    );
  }

  Widget _divider() {
    return Row(
      children: [
        Expanded(
          child: Container(height: 1, color: _gold.withOpacity(0.7)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Transform.rotate(
            angle: 0.785398,
            child: Container(width: 7, height: 7, color: _gold),
          ),
        ),
        Expanded(
          child: Container(height: 1, color: _gold.withOpacity(0.7)),
        ),
      ],
    );
  }
}
