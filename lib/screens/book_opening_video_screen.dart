import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../audio/background_music_service.dart';
import '../main.dart';
import 'awakening_scene_screen.dart';
import 'memory_book_registration_screen.dart';

/// Полноэкранное видео открытия книги (перелистывание страниц).
/// Принимает уже созданный и проинициализированный [controller] —
/// его готовят заранее на главном экране, чтобы тут не было чёрного
/// экрана, пока видео буферизуется.
///
/// Пока это видео (и следующий за ним пролог) на экране — фоновая
/// музыка главного меню поставлена на паузу.
///
/// Как только видео доигрывает до конца — автоматически переходит
/// на StoryIntroScreen. Можно тапнуть "Пропустить" в углу.
class BookOpeningVideoScreen extends StatefulWidget {
  const BookOpeningVideoScreen({
    super.key,
    required this.controller,
    this.fallback,
  });

  final VideoPlayerController controller;

  /// Что показать, пока видео ещё не готово. Обычно сюда передают
  /// точную копию главного экрана, чтобы переход был совсем незаметным.
  final Widget? fallback;

  @override
  State<BookOpeningVideoScreen> createState() =>
      _BookOpeningVideoScreenState();
}

class _BookOpeningVideoScreenState extends State<BookOpeningVideoScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    // Музыке главного меню тут не место — на видео и дальше в прологе
    // должно быть тихо (или своя атмосферная озвучка, если появится).
    BackgroundMusicService.instance.pause();

    final controller = widget.controller;

    if (controller.value.isInitialized) {
      controller.play();
    } else {
      // Подстраховка на случай, если контроллер почему-то не был
      // проинициализирован заранее (не должно происходить в норме)
      controller.initialize().then((_) {
        if (mounted) setState(() {});
        controller.play();
      });
    }

    controller.addListener(_checkIfFinished);
  }

  void _checkIfFinished() {
    final value = widget.controller.value;
    if (!value.isInitialized || _navigated) return;

    final almostDone =
        value.position >= value.duration - const Duration(milliseconds: 150);
    if (almostDone && !value.isPlaying) {
      _goToPrologue();
    }
  }

  void _goToPrologue() {
    if (_navigated) return;
    _navigated = true;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        // ВАЖНО: используем ctx из builder-а НОВОГО экрана, а не context
        // текущего (умирающего) состояния. pushReplacement уничтожает
        // BookOpeningVideoScreenState сразу же, поэтому если передать
        // сюда просто "_goToRegistration" (метод, использующий this.context),
        // то к моменту, когда игрок дотапает пролог до конца и вызовется
        // onFinished, этот context уже будет unmounted — и приложение
        // упадёт с ошибкой "This widget has been unmounted".
        //
        // ctx здесь принадлежит AwakeningSceneScreen — экрану, который
        // в этот момент жив, поэтому именно его и нужно передавать дальше.
        builder: (ctx) => AwakeningSceneScreen(
          onFinished: () => _goToRegistration(ctx),
        ),
      ),
    );
  }

  /// Срабатывает по концовке пролога — тап на "Наше путешествие
  /// начинается" — и открывает регистрацию персонажа в Книге
  /// воспоминаний.
  ///
  /// Принимает [ctx] — живой context экрана AwakeningSceneScreen на
  /// момент вызова (а не context этого, уже уничтоженного к тому
  /// моменту, состояния).
  void _goToRegistration(BuildContext ctx) {
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MemoryBookRegistrationScreen(
          onComplete: (data) {
            // TODO: сохранить data.name / data.language / data.reasons /
            // data.interests / data.level (SharedPreferences, бэкенд,
            // состояние приложения — на ваш выбор)
            Navigator.of(ctx).pushReplacement(
              MaterialPageRoute(builder: (_) => const BlackScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_checkIfFinished);
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReady = widget.controller.value.isInitialized;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (!isReady && widget.fallback != null) widget.fallback!,

          if (isReady)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: widget.controller.value.size.width,
                height: widget.controller.value.size.height,
                child: VideoPlayer(widget.controller),
              ),
            ),

          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextButton(
                  onPressed: _goToPrologue,
                  child: const Text(
                    'Пропустить',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
