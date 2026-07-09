import 'package:flutter/material.dart';

/// Данные, которые игрок заполняет во время регистрации.
/// Передаются наружу через [MemoryBookRegistrationScreen.onComplete],
/// когда пользователь подтверждает страницу-сводку в конце.
class MemoryBookRegistrationData {
  MemoryBookRegistrationData({
    required this.name,
    required this.nameMode,
    required this.language,
    required this.reasons,
    required this.interests,
    required this.level,
  });

  final String name;
  final String? nameMode; // 'real' | 'new'
  final String language; // 'fr' и т.д.
  final Set<String> reasons;
  final Set<String> interests;
  final String? level; // 'none' | 'a1' ... 'c1'
}

/// Экран регистрации «Книга воспоминаний».
/// Показывает интро от Люми, 5 страниц-вопросов и финальную сводку,
/// оформленные как разворот книги: пергамент, золотая рамка, звёздный фон.
class MemoryBookRegistrationScreen extends StatefulWidget {
  const MemoryBookRegistrationScreen({super.key, required this.onComplete});

  /// Вызывается, когда игрок подтверждает сводку и нажимает
  /// «Начать историю».
  final ValueChanged<MemoryBookRegistrationData> onComplete;

  @override
  State<MemoryBookRegistrationScreen> createState() =>
      _MemoryBookRegistrationScreenState();
}

class _MemoryBookRegistrationScreenState
    extends State<MemoryBookRegistrationScreen> {
  static const _gold = Color(0xFFB8892B);
  static const _goldLight = Color(0xFFE0B866);
  static const _ink = Color(0xFF3B2F1E);
  static const _inkSoft = Color(0xFF5C4A30);
  static const _gemDeep = Color(0xFF1F5C9E);

  int _step = 0; // 0 = интро, 1..5 = страницы, 6 = сводка
  final _nameController = TextEditingController();
  String? _nameMode;
  String _language = 'fr';
  final Set<String> _reasons = {};
  final Set<String> _interests = {};
  String? _level;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _goTo(int step) {
    setState(() => _step = step.clamp(0, 6));
  }

  @override
  Widget build(BuildContext context) {
    // Ширина экрана определяет, насколько "тесно" на карточке —
    // используется ниже, чтобы чуть уменьшить внутренние отступы
    // карточки на маленьких телефонах.
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 380;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Иллюстрация открытой книги — фон именно для регистрации,
          // отдельно от фона главного меню.
          Image.asset('assets/images/book_open.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.45)),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isNarrow ? 14 : 24,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.04),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    ),
                    child: KeyedSubtree(
                      key: ValueKey(_step),
                      child: _buildStep(isNarrow),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(bool isNarrow) {
    switch (_step) {
      case 0:
        return _buildIntro();
      case 1:
        return _buildNameStep();
      case 2:
        return _buildLanguageStep(isNarrow);
      case 3:
        return _buildReasonsStep(isNarrow);
      case 4:
        return _buildInterestsStep(isNarrow);
      case 5:
        return _buildLevelStep(isNarrow);
      default:
        return _buildSummaryStep();
    }
  }

  // ---------------------------------------------------------------------
  // Общие строительные блоки
  // ---------------------------------------------------------------------

  Widget _lumiLine(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          const Text(
            'ЛЮМИ',
            style: TextStyle(
              color: _gemDeep,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _goldLight,
              fontSize: 16,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required List<Widget> children, bool isNarrow = false}) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        isNarrow ? 18 : 28,
        isNarrow ? 22 : 30,
        isNarrow ? 18 : 28,
        isNarrow ? 18 : 24,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEFE2C4), Color(0xFFE6D5AC)],
        ),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _gold.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _stepLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text.toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _gold,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.5,
          ),
        ),
      );

  Widget _title(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _ink,
            fontSize: 21,
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
        ),
      );

  Widget _subtitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 22),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _inkSoft,
            fontSize: 14.5,
            fontStyle: FontStyle.italic,
          ),
        ),
      );

  Widget _progressDots() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (i) {
          final page = i + 1;
          final active = page == _step;
          final done = page < _step;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3.5),
            width: active ? 8 : 6,
            height: active ? 8 : 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active
                  ? _gold
                  : done
                      ? _gemDeep
                      : _gold.withOpacity(0.3),
            ),
          );
        }),
      ),
    );
  }

  Widget _navRow({required bool canNext, VoidCallback? onNext}) {
    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => _goTo(_step - 1),
            child: const Text(
              '← Назад',
              style: TextStyle(
                color: _inkSoft,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: canNext ? (onNext ?? () => _goTo(_step + 1)) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _gemDeep,
              disabledBackgroundColor: _gemDeep.withOpacity(0.35),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              'ДАЛЕЕ →',
              style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  /// Плитка выбора варианта — используется на всех страницах с опциями.
  ///
  /// Раньше высота плитки задавалась через childAspectRatio в
  /// _choiceGrid — на узких экранах (телефон) ширина плитки уменьшалась,
  /// а вместе с ней пропорционально сжималась и высота, из-за чего текст
  /// физически не помещался и "вылезал" за рамки плашки. Теперь высота
  /// плитки задаётся отдельно и фиксированно (см. mainAxisExtent в
  /// _choiceGrid), а сам текст умеет переноситься на 2 строки вместо
  /// того, чтобы вылезать наружу или обрезаться посередине.
  Widget _choiceTile({
    required String label,
    required bool selected,
    IconData icon = Icons.auto_awesome,
    bool soon = false,
    VoidCallback? onTap,
  }) {
    return Opacity(
      opacity: soon ? 0.5 : 1,
      child: InkWell(
        onTap: soon ? null : onTap,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? _gemDeep.withOpacity(0.16)
                : Colors.white.withOpacity(0.28),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: selected ? _gemDeep : _ink.withOpacity(0.25),
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 16, color: selected ? _gemDeep : _inkSoft),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _ink,
                    fontSize: 13,
                    height: 1.15,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (soon) ...[
                const SizedBox(width: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: _ink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Text(
                    'скоро',
                    style: TextStyle(fontSize: 9, color: _inkSoft),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// [tileHeight] задаёт фиксированную высоту плитки, не зависящую от
  /// ширины экрана — именно это чинит "слетающий" текст на телефонах.
  /// Для 3 колонок (страница уровня) плитка чуть выше по умолчанию,
  /// так как там меньше горизонтального места и текст чаще переносится
  /// на 2 строки.
  Widget _choiceGrid(
    List<Widget> tiles, {
    int columns = 2,
    double? tileHeight,
  }) {
    final height = tileHeight ?? (columns >= 3 ? 58.0 : 50.0);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tiles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: height,
      ),
      itemBuilder: (context, index) => tiles[index],
    );
  }

  // ---------------------------------------------------------------------
  // Страница 0 — интро
  // ---------------------------------------------------------------------

  Widget _buildIntro() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _lumiLine(
          'Каждая жизнь начинается с первой страницы.\nДавай напишем твою историю.',
        ),
        _card(children: [
          _stepLabel('Книга воспоминаний'),
          _title('Открыть новую страницу?'),
          _subtitle('Твоя история ещё не написана'),
          Center(
            child: ElevatedButton(
              onPressed: () => _goTo(1),
              style: ElevatedButton.styleFrom(
                backgroundColor: _gemDeep,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              child: const Text(
                'НАЧАТЬ',
                style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 2),
              ),
            ),
          ),
        ]),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // Страница 1 — имя
  // ---------------------------------------------------------------------

  Widget _buildNameStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _lumiLine('Каждое имя в этой книге что-то значит.'),
        _card(children: [
          _progressDots(),
          _stepLabel('Страница 1'),
          _title('Как тебя будут называть в этом мире?'),
          _subtitle('Ты можешь быть собой или создать нового героя'),
          TextField(
            controller: _nameController,
            textAlign: TextAlign.center,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(color: _ink, fontSize: 18),
            decoration: InputDecoration(
              hintText: 'Впиши своё имя...',
              hintStyle:
                  TextStyle(color: _ink.withOpacity(0.4), fontStyle: FontStyle.italic),
              filled: true,
              fillColor: Colors.white.withOpacity(0.35),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: _ink.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: _gemDeep, width: 1.6),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _choiceTile(
            label: 'Использовать своё настоящее имя',
            selected: _nameMode == 'real',
            onTap: () => setState(() => _nameMode = 'real'),
          ),
          const SizedBox(height: 10),
          _choiceTile(
            label: 'Придумать нового героя',
            selected: _nameMode == 'new',
            onTap: () => setState(() => _nameMode = 'new'),
          ),
          _navRow(canNext: _nameController.text.trim().isNotEmpty),
        ]),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // Страница 2 — язык
  // ---------------------------------------------------------------------

  Widget _buildLanguageStep(bool isNarrow) {
    final languages = [
      ('fr', 'Французский', false),
      ('en', 'Английский', true),
      ('es', 'Испанский', true),
      ('de', 'Немецкий', true),
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _lumiLine('Каждый язык открывает новую главу мира.'),
        _card(isNarrow: isNarrow, children: [
          _progressDots(),
          _stepLabel('Страница 2'),
          _title('Какой язык ты хочешь освоить?'),
          _subtitle('Первая глава уже ждёт тебя'),
          _choiceGrid(
            languages
                .map((l) => _choiceTile(
                      label: l.$2,
                      selected: _language == l.$1,
                      icon: Icons.language,
                      soon: l.$3,
                      onTap: () => setState(() => _language = l.$1),
                    ))
                .toList(),
          ),
          _navRow(canNext: true),
        ]),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // Страница 3 — причины путешествия (мультивыбор)
  // ---------------------------------------------------------------------

  Widget _buildReasonsStep(bool isNarrow) {
    final reasons = [
      ('travel', 'Путешествия', Icons.flight_takeoff),
      ('work', 'Работа', Icons.work_outline),
      ('love', 'Любовь к языку', Icons.favorite_border),
      ('games', 'Игры', Icons.videogame_asset_outlined),
      ('study', 'Учёба', Icons.school_outlined),
      ('explore', 'Хочу открыть новый мир', Icons.public),
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _lumiLine('Каждый путник знает, зачем отправился в путь.'),
        _card(isNarrow: isNarrow, children: [
          _progressDots(),
          _stepLabel('Страница 3'),
          _title('Почему ты отправляешься в это путешествие?'),
          _subtitle('Можно выбрать несколько причин'),
          _choiceGrid(
            reasons
                .map((r) => _choiceTile(
                      label: r.$2,
                      icon: r.$3,
                      selected: _reasons.contains(r.$1),
                      onTap: () => setState(() {
                        _reasons.contains(r.$1)
                            ? _reasons.remove(r.$1)
                            : _reasons.add(r.$1);
                      }),
                    ))
                .toList(),
            // Некоторые причины ("Хочу открыть новый мир", "Любовь к
            // языку") длиннее остальных и на телефоне почти всегда
            // переносятся на 2 строки — даём чуть больше высоты.
            tileHeight: 56,
          ),
          _navRow(canNext: _reasons.isNotEmpty),
        ]),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // Страница 4 — интересы (мультивыбор)
  // ---------------------------------------------------------------------

  Widget _buildInterestsStep(bool isNarrow) {
    final interests = [
      ('games', 'Игры', Icons.videogame_asset_outlined),
      ('music', 'Музыка', Icons.music_note_outlined),
      ('sport', 'Спорт', Icons.sports_soccer),
      ('art', 'Рисование', Icons.brush_outlined),
      ('books', 'Книги', Icons.menu_book_outlined),
      ('cars', 'Автомобили', Icons.directions_car_outlined),
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _lumiLine('То, что тебе нравится, оживит твою историю.'),
        _card(isNarrow: isNarrow, children: [
          _progressDots(),
          _stepLabel('Страница 4'),
          _title('Что тебе нравится?'),
          _subtitle('Выбери всё, что откликается'),
          _choiceGrid(
            interests
                .map((i) => _choiceTile(
                      label: i.$2,
                      icon: i.$3,
                      selected: _interests.contains(i.$1),
                      onTap: () => setState(() {
                        _interests.contains(i.$1)
                            ? _interests.remove(i.$1)
                            : _interests.add(i.$1);
                      }),
                    ))
                .toList(),
          ),
          _navRow(canNext: _interests.isNotEmpty),
        ]),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // Страница 5 — уровень французского
  // ---------------------------------------------------------------------

  Widget _buildLevelStep(bool isNarrow) {
    final levels = [
      ('none', 'Никогда не изучал'),
      ('a1', 'A1'),
      ('a2', 'A2'),
      ('b1', 'B1'),
      ('b2', 'B2'),
      ('c1', 'C1'),
    ];
    final hint = _level == null
        ? ''
        : _level == 'none'
            ? 'Твоя история начнётся с самого рождения.'
            : 'Твоя история начнётся с этапа жизни, что соответствует уровню '
                '${levels.firstWhere((l) => l.$1 == _level).$2}.';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _lumiLine('Скажи, с какой страницы начать твою историю.'),
        _card(isNarrow: isNarrow, children: [
          _progressDots(),
          _stepLabel('Страница 5'),
          _title('Ты уже знаком с французским?'),
          _subtitle('Это определит, с чего начнётся твоя история'),
          _choiceGrid(
            levels
                .map((l) => _choiceTile(
                      label: l.$2,
                      icon: Icons.auto_awesome,
                      selected: _level == l.$1,
                      onTap: () => setState(() => _level = l.$1),
                    ))
                .toList(),
            columns: 3,
          ),
          if (hint.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Text(
                hint,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _inkSoft,
                  fontSize: 13.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          _navRow(canNext: _level != null),
        ]),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // Финал — сводка
  // ---------------------------------------------------------------------

  Widget _buildSummaryStep() {
    const langNames = {'fr': 'Французский'};
    const reasonNames = {
      'travel': 'Путешествия',
      'work': 'Работа',
      'love': 'Любовь к языку',
      'games': 'Игры',
      'study': 'Учёба',
      'explore': 'Хочу открыть новый мир',
    };
    const interestNames = {
      'games': 'Игры',
      'music': 'Музыка',
      'sport': 'Спорт',
      'art': 'Рисование',
      'books': 'Книги',
      'cars': 'Автомобили',
    };
    const levelNames = {
      'none': 'Никогда не изучал',
      'a1': 'A1',
      'a2': 'A2',
      'b1': 'B1',
      'b2': 'B2',
      'c1': 'C1',
    };

    Widget row(String label, String value) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: _inkSoft, fontStyle: FontStyle.italic)),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      color: _ink, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );

    final name = _nameController.text.trim();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _lumiLine('Страница записана. Книга запомнит тебя навсегда.'),
        _card(children: [
          _stepLabel('Твоя первая запись'),
          _title(name.isEmpty ? 'Безымянный герой' : name),
          _subtitle('Глава первая вот-вот начнётся'),
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: _ink.withOpacity(0.15))),
            ),
            child: Column(
              children: [
                Divider(color: _ink.withOpacity(0.15), height: 1),
                row('Язык', langNames[_language] ?? '—'),
                Divider(color: _ink.withOpacity(0.15), height: 1),
                row(
                  'Причина пути',
                  _reasons.map((r) => reasonNames[r]).join(', '),
                ),
                Divider(color: _ink.withOpacity(0.15), height: 1),
                row(
                  'Интересы',
                  _interests.map((i) => interestNames[i]).join(', '),
                ),
                Divider(color: _ink.withOpacity(0.15), height: 1),
                row('Уровень', levelNames[_level] ?? '—'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => _goTo(5),
                child: const Text(
                  '← Изменить',
                  style: TextStyle(color: _inkSoft, fontWeight: FontWeight.w600),
                ),
              ),
              ElevatedButton(
                onPressed: () => widget.onComplete(
                  MemoryBookRegistrationData(
                    name: name,
                    nameMode: _nameMode,
                    language: _language,
                    reasons: _reasons,
                    interests: _interests,
                    level: _level,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _gemDeep,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                child: const Text(
                  'НАЧАТЬ ИСТОРИЮ',
                  style:
                      TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1),
                ),
              ),
            ],
          ),
        ]),
      ],
    );
  }
}
