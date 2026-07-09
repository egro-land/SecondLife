import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../audio/background_music_service.dart';
import 'awakening_scene_screen.dart';

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
      builder: (_) => const AwakeningSceneScreen(),
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
