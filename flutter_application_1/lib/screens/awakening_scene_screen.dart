import 'package:flutter/material.dart';

import '../models/game_progress.dart';
import '../services/auth_service.dart';

/// Один "такт" сцены — то, что может показываться между тапами игрока.
/// Если текст такта не помещается в отведённое число строк, он сам
/// автоматически разобьётся на несколько "страниц" внутри одного такта
/// (см. _paginateText) — тап пролистывает их, прежде чем перейти дальше.
class SceneBeat {
  const SceneBeat({this.text, this.speaker, this.frame});

  final String? text;
  final String? speaker;
  final int? frame;
}

/// Сценарий сцены "Глава I. Рождение — Сцена 1. Темнота".
const List<SceneBeat> awakeningScript = [
  SceneBeat(text: '...'),
  SceneBeat(text: 'Тишина.'),
  SceneBeat(text: '...'),
  SceneBeat(text: 'Где-то далеко слышится ветер.'),
  SceneBeat(text: '...'),
  SceneBeat(text: 'Тук...'),
  SceneBeat(text: '...'),
  SceneBeat(text: 'Тук...'),
  SceneBeat(text: '...'),
  SceneBeat(text: 'Сердце начинает биться чуть быстрее.\nТук... Тук...'),
  SceneBeat(
    text: 'В темноте появляется маленькая голубая искра.\nСовсем крошечная.',
    frame: 1,
  ),
  SceneBeat(text: 'Она медленно приближается.', frame: 2),
  SceneBeat(text: 'Становится ярче.', frame: 3),
  SceneBeat(
    text: 'Вокруг неё начинают кружиться маленькие светящиеся частицы.',
    frame: 4,
  ),
  SceneBeat(
    text: 'Искра превращается в маленькую девочку.\n'
        'Она будто соткана из света.\nБелые волосы.\nГолубые глаза.\n'
        'Она медленно открывает их.',
    frame: 5,
  ),
  SceneBeat(text: 'Она удивлённо смотрит по сторонам.', frame: 6),
  SceneBeat(text: 'Потом замечает игрока.', frame: 7),
  SceneBeat(text: 'Несколько секунд молчит.', frame: 8),
  SceneBeat(text: 'Лёгкая улыбка.', frame: 9),
  SceneBeat(speaker: 'Люми', text: '— Привет...'),
  SceneBeat(text: 'Она наклоняет голову.'),
  SceneBeat(speaker: 'Люми', text: '— Ты...'),
  SceneBeat(speaker: 'Люми', text: '— Ты тоже только что проснулся?'),
  SceneBeat(text: 'Она снова осматривается.'),
  SceneBeat(speaker: 'Люми', text: '— Как странно...'),
  SceneBeat(speaker: 'Люми', text: '— Здесь ничего нет...'),
  SceneBeat(speaker: 'Люми', text: '— Только темнота...'),
  SceneBeat(
    text: 'Она делает маленький шаг вперёд.\nВернее...\n'
        'Она не идёт.\nОна плавно подплывает ближе.',
  ),
  SceneBeat(speaker: 'Люми', text: '— Меня зовут...'),
  SceneBeat(text: 'Она вдруг замолкает.'),
  SceneBeat(speaker: 'Люми', text: '— ...'),
  SceneBeat(
    text: 'Она касается рукой своей груди.\nБудто пытается что-то вспомнить.',
  ),
  SceneBeat(speaker: 'Люми', text: '— Подожди...'),
  SceneBeat(speaker: 'Люми', text: '— Почему...'),
  SceneBeat(speaker: 'Люми', text: '— Я не могу вспомнить...'),
  SceneBeat(text: 'Она закрывает глаза.'),
  SceneBeat(speaker: 'Люми', text: '— Кажется...'),
  SceneBeat(speaker: 'Люми', text: '— Меня зовут...'),
  SceneBeat(text: 'Долгая пауза.'),
  SceneBeat(speaker: 'Люми', text: '— Люми.'),
  SceneBeat(text: 'Она облегчённо улыбается.'),
  SceneBeat(speaker: 'Люми', text: '— Да...'),
  SceneBeat(speaker: 'Люми', text: '— Теперь вспомнила.'),
  SceneBeat(speaker: 'Люми', text: '— Меня зовут Люми.'),
  SceneBeat(text: 'Она внимательно смотрит прямо в глаза игроку.'),
  SceneBeat(speaker: 'Люми', text: '— А тебя?..'),
  SceneBeat(text: 'Она улыбается.'),
  SceneBeat(speaker: 'Люми', text: '— Хотя...'),
  SceneBeat(speaker: 'Люми', text: '— Наверное...'),
  SceneBeat(speaker: 'Люми', text: '— Ты тоже пока ничего не помнишь.'),
  SceneBeat(text: 'Вдалеке появляется едва заметный тёплый свет.'),
  SceneBeat(text: 'Люми оборачивается.'),
  SceneBeat(speaker: 'Люми', text: '— Смотри...'),
  SceneBeat(speaker: 'Люми', text: '— Там что-то есть.'),
  SceneBeat(text: 'Свет становится ярче.'),
  SceneBeat(text: 'Слышится чей-то голос.\nОчень далеко.\nСовсем неразборчиво.'),
  SceneBeat(text: 'Ещё один голос.'),
  SceneBeat(text: 'Кажется...\nОни разговаривают.'),
  SceneBeat(text: 'Люми внимательно прислушивается.'),
  SceneBeat(speaker: 'Люми', text: '— Ты слышишь?..'),
  SceneBeat(speaker: 'Люми', text: '— Кто-то говорит...'),
  SceneBeat(speaker: 'Люми', text: '— Но...'),
  SceneBeat(speaker: 'Люми', text: '— Я не могу разобрать слова...'),
  SceneBeat(text: 'Голоса становятся ближе.'),
  SceneBeat(text: 'Свет почти полностью заполняет экран.'),
  SceneBeat(text: 'Люми слегка улыбается.'),
  SceneBeat(speaker: 'Люми', text: '— Кажется...'),
  SceneBeat(speaker: 'Люми', text: '— Наше путешествие начинается.'),
];

const _gold = Color(0xFFE8C878);
const _panelBg = Color(0xFF10193A);

/// Сколько строк максимум помещается в панель за один раз, прежде чем
/// текст автоматически поделится на страницы.
const int _maxLinesPerPage = 3;

/// Считает, на сколько визуальных строк развернётся [line] при переносе
/// по ширине [maxWidth] заданным стилем.
int _wrappedLineCount(String line, TextStyle style, double maxWidth) {
  if (line.isEmpty) return 1;
  final painter = TextPainter(
    text: TextSpan(text: line, style: style),
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: maxWidth);
  return painter.computeLineMetrics().length;
}

/// Делит текст такта на страницы так, чтобы каждая страница помещалась
/// в [_maxLinesPerPage] строк при ширине [maxWidth]. Явные переносы
/// строк (\n) в исходном тексте уважаются — каждая "логическая" строка
/// либо целиком попадает на текущую страницу, либо переносит всё, что
/// не поместилось, на следующую.
List<String> _paginateText(String text, TextStyle style, double maxWidth) {
  final logicalLines = text.split('\n');
  final pages = <String>[];
  var current = <String>[];
  var currentLineCount = 0;

  for (final line in logicalLines) {
    final lineCount =
        _wrappedLineCount(line, style, maxWidth).clamp(1, _maxLinesPerPage);
    if (currentLineCount + lineCount > _maxLinesPerPage && current.isNotEmpty) {
      pages.add(current.join('\n'));
      current = [];
      currentLineCount = 0;
    }
    current.add(line);
    currentLineCount += lineCount;
  }
  if (current.isNotEmpty) pages.add(current.join('\n'));
  return pages.isEmpty ? [''] : pages;
}

/// Ищет, какой кадр иллюстрации должен быть показан для такта с
/// индексом [index] — это кадр самого такта, если он задан, а иначе
/// кадр ближайшего предыдущего такта, у которого он был задан (кадры
/// "держатся" на экране, пока не появится следующий).
///
/// Используется как при пролистывании вперёд, так и назад, а также при
/// восстановлении сохранённого прогресса — благодаря этому всегда
/// показывается корректный для конкретного такта кадр.
int? _frameForBeat(int index) {
  for (var i = index; i >= 0; i--) {
    final frame = awakeningScript[i].frame;
    if (frame != null) return frame;
  }
  return null;
}

/// Экран сцены "Темнота": полноэкранная картинка + декоративная
/// текстовая вставка внизу (в духе визуальных новелл вроде "Бесконечного
/// лета") с автоматическим делением длинных реплик на страницы.
class AwakeningSceneScreen extends StatefulWidget {
  const AwakeningSceneScreen({
    super.key,
    this.onFinished,
    this.initialBeatIndex,
    this.initialPageIndex = 0,
    this.readOnly = false,
  });

  final VoidCallback? onFinished;

  /// Если задан (>= 0) — сцена открывается сразу на этом такте вместо
  /// начального "нажмите на экран". Используется при восстановлении
  /// сохранённого прогресса игрока (см. AuthGate).
  final int? initialBeatIndex;

  /// Страница внутри initialBeatIndex, на которой нужно открыть сцену.
  final int initialPageIndex;

  /// Если true — сцена открыта просто для повторного просмотра (когда
  /// игрок уже прошёл пролог и зашёл посмотреть диалог с Люми ещё раз
  /// со страницы "Книги воспоминаний"). В этом режиме прогресс не
  /// перезаписывается — обычный ход тактов не должен "откатить" уже
  /// сохранённое место в истории.
  final bool readOnly;

  @override
  State<AwakeningSceneScreen> createState() => _AwakeningSceneScreenState();
}

class _AwakeningSceneScreenState extends State<AwakeningSceneScreen> {
  static const _framesPath = 'assets/images/lumi_frames';
  static const _textStyle = TextStyle(color: Colors.white, fontSize: 16, height: 1.4);

  int _beatIndex = -1;
  int? _currentFrame;

  List<String> _pages = const [];
  int _pageIndex = 0;

  bool _resumedFromSaved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Одноразовая инициализация из сохранённого прогресса. Делается тут
    // (а не в initState), потому что для расчёта переносов текста нужен
    // MediaQuery, который в initState ещё не гарантированно доступен.
    if (_resumedFromSaved) return;
    _resumedFromSaved = true;

    final startBeat = widget.initialBeatIndex;
    if (startBeat != null && startBeat >= 0) {
      final screenWidth = MediaQuery.of(context).size.width;
      final textAreaWidth = screenWidth - 16 * 2 - 20 * 2;
      _beatIndex = startBeat.clamp(0, awakeningScript.length - 1);
      _loadBeat(_beatIndex, textAreaWidth);
      _pageIndex = widget.initialPageIndex.clamp(0, _pages.length - 1);
    }
  }

  void _loadBeat(int index, double textAreaWidth) {
    final beat = awakeningScript[index];
    // Кадр определяется по индексу такта, а не "запоминается" по ходу
    // движения вперёд — это важно, чтобы пролистывание назад и
    // восстановление сохранённого прогресса показывали правильный кадр.
    _currentFrame = _frameForBeat(index);
    _pages = _paginateText(beat.text ?? '', _textStyle, textAreaWidth);
    _pageIndex = 0;
  }

  bool get _canGoBack => _beatIndex > 0 || _pageIndex > 0;

  /// Сохраняет текущее место в сцене, чтобы при следующем запуске
  /// приложения игрок мог продолжить именно отсюда. Ничего не делает
  /// в readOnly-режиме (повторный просмотр не должен трогать реальный
  /// прогресс).
  void _persistProgress() {
    if (widget.readOnly) return;
    if (_beatIndex < 0) return;
    AuthService.instance.saveProgress(
      GameProgress(
        stage: GameStage.awakening,
        beatIndex: _beatIndex,
        pageIndex: _pageIndex,
      ).toJson(),
    );
  }

  void _onTap(double textAreaWidth) {
    setState(() {
      // Ещё не первый такт показан вообще
      if (_beatIndex == -1) {
        _beatIndex = 0;
        _loadBeat(_beatIndex, textAreaWidth);
        _persistProgress();
        return;
      }

      // Внутри текущего такта есть ещё не показанные страницы текста
      if (_pageIndex < _pages.length - 1) {
        _pageIndex++;
        _persistProgress();
        return;
      }

      // Последний такт и последняя страница — сцена закончена
      if (_beatIndex >= awakeningScript.length - 1) {
        // В обычном режиме прогресс переходит на следующий этап —
        // регистрацию персонажа — чтобы при повторном запуске игрок не
        // начинал пролог заново. В readOnly-режиме это не нужно: игрок
        // и так уже на этапе регистрации, просто зашёл посмотреть
        // диалог ещё раз.
        if (!widget.readOnly) {
          AuthService.instance.saveProgress(
            GameProgress(stage: GameStage.registration).toJson(),
          );
        }
        widget.onFinished?.call();
        return;
      }

      _beatIndex++;
      _loadBeat(_beatIndex, textAreaWidth);
      _persistProgress();
    });
  }

  /// Листает на одну страницу/такт назад. Сначала откатывает страницы
  /// внутри текущего такта (если реплика была разбита на несколько), а
  /// когда они кончаются — переходит к последней странице предыдущего
  /// такта.
  void _onBack(double textAreaWidth) {
    if (!_canGoBack) return;
    setState(() {
      if (_pageIndex > 0) {
        _pageIndex--;
        _persistProgress();
        return;
      }
      _beatIndex--;
      _loadBeat(_beatIndex, textAreaWidth);
      _pageIndex = _pages.length - 1;
      _persistProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Ширина области текста = ширина экрана минус внешние отступы панели
    // (16+16) и внутренние отступы контента (20+20)
    final textAreaWidth = screenWidth - 16 * 2 - 20 * 2;

    final beat = _beatIndex >= 0 ? awakeningScript[_beatIndex] : null;
    final pageText = _pages.isNotEmpty ? _pages[_pageIndex] : null;
    final hasMorePages = _pageIndex < _pages.length - 1;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onTap(textAreaWidth),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            if (_currentFrame != null)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 450),
                child: Image.asset(
                  '$_framesPath/frame_$_currentFrame.png',
                  key: ValueKey(_currentFrame),
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                  width: double.infinity,
                  height: double.infinity,
                ),
              )
            else
              const SizedBox.expand(child: ColoredBox(color: Colors.black)),

            if (beat != null)
              Positioned(
                left: 16,
                right: 16,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  child: _DialogueInsert(
                    speaker: beat.speaker,
                    text: pageText ?? '',
                    beatKey: '$_beatIndex-$_pageIndex',
                    hasMorePages: hasMorePages,
                  ),
                ),
              ),

            if (_beatIndex == -1)
              Positioned(
                bottom: 60,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'нажмите на экран',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

            // Кнопка "назад" — видна, только когда действительно есть
            // куда возвращаться (не на самом первом такте/странице).
            if (_canGoBack)
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Material(
                      color: Colors.black.withOpacity(0.35),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => _onBack(textAreaWidth),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: _gold,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Декоративная текстовая вставка — тёмно-синяя панель с золотой
/// окантовкой, ромбиками по углам и плашкой имени говорящего, слегка
/// выступающей над верхним краем панели.
class _DialogueInsert extends StatelessWidget {
  const _DialogueInsert({
    required this.speaker,
    required this.text,
    required this.beatKey,
    required this.hasMorePages,
  });

  final String? speaker;
  final String text;
  final String beatKey;
  final bool hasMorePages;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Сама панель
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
            decoration: BoxDecoration(
              color: _panelBg.withOpacity(0.88),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _gold, width: 1.3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Row(
                key: ValueKey(beatKey),
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      text,
                      maxLines: _maxLinesPerPage,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _TapIndicator(blinking: true, morePages: hasMorePages),
                ],
              ),
            ),
          ),

          // Ромбики по углам панели
          const _CornerDiamond(alignment: Alignment.topLeft),
          const _CornerDiamond(alignment: Alignment.topRight),
          const _CornerDiamond(alignment: Alignment.bottomLeft),
          const _CornerDiamond(alignment: Alignment.bottomRight),

          // Плашка с именем говорящего — по центру верхней границы панели,
          // ровно посередине как по горизонтали, так и по вертикали
          // (граница панели проходит через середину плашки)
          if (speaker != null)
            Align(
              alignment: Alignment.topCenter,
              child: FractionalTranslation(
                translation: const Offset(0, -0.5),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: _panelBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _gold, width: 1.2),
                  ),
                  child: Text(
                    speaker!,
                    style: const TextStyle(
                      color: _gold,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
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

class _CornerDiamond extends StatelessWidget {
  const _CornerDiamond({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: Offset(
          alignment.x * -4,
          alignment.y * -4,
        ),
        child: Transform.rotate(
          angle: 0.785398,
          child: Container(width: 7, height: 7, color: _gold),
        ),
      ),
    );
  }
}

/// Маленький индикатор "тапни, чтобы продолжить". Форма чуть меняется,
/// если внутри такта ещё остались непоказанные страницы текста —
/// две галочки вместо одной, как намёк "тут ещё есть текст".
class _TapIndicator extends StatefulWidget {
  const _TapIndicator({required this.blinking, required this.morePages});

  final bool blinking;
  final bool morePages;

  @override
  State<_TapIndicator> createState() => _TapIndicatorState();
}

class _TapIndicatorState extends State<_TapIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.3, end: 1.0).animate(_controller),
      child: Icon(
        widget.morePages ? Icons.keyboard_double_arrow_down_rounded : Icons.expand_more_rounded,
        color: _gold,
        size: 20,
      ),
    );
  }
}

// Как подключить:
//
// 1. Кадры лежат в assets/images/lumi_frames/frame_1.png ... frame_9.png —
//    добавьте в pubspec.yaml:
//      flutter:
//        assets:
//          - assets/images/lumi_frames/
//
// 2. Переход сюда уже настроен в BookOpeningVideoScreen._goToPrologue().
