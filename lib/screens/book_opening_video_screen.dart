import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'story_intro_screen.dart';

/// Полноэкранное видео открытия книги (перелистывание страниц).
/// Принимает уже созданный (и, в идеале, уже проинициализированный)
/// [controller] — его нужно начать готовить заранее, ещё на главном
/// экране, чтобы тут не было ни секунды чёрного фона при переходе.
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

  /// Что показать, пока видео ещё не готово (доля секунды, если не
  /// успело подгрузиться заранее). Обычно сюда передают точную копию
  /// главного экрана, чтобы переход был совсем незаметным.
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
    final controller = widget.controller;

    if (controller.value.isInitialized) {
      controller.play();
    } else {
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
      MaterialPageRoute(builder: (_) => const StoryIntroScreen()),
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
          // Пока видео не готово — показываем главный экран как заглушку,
          // чтобы переход не "мигал" чёрным
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

          // Кнопка пропуска
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
