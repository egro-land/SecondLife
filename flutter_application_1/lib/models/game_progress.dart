/// На каком крупном этапе приложения сейчас находится игрок.
enum GameStage { awakening, registration, mainMenu }

/// Прогресс игрока — что именно сохраняется на сервере (через
/// AuthService.saveProgress/loadProgress) и восстанавливается при
/// следующем входе.
///
/// Названия полей в JSON (beat_index, page_index) — это формат, который
/// ждёт бэкенд (см. backend/app/schemas.py: ProgressIn/ProgressOut).
class GameProgress {
  GameProgress({
    required this.stage,
    this.beatIndex = 0,
    this.pageIndex = 0,
  });

  /// Этап: пролог с Люми, регистрация персонажа или уже главное меню.
  final GameStage stage;

  /// Индекс "такта" сцены пролога (см. awakeningScript в
  /// awakening_scene_screen.dart). Имеет смысл только при
  /// stage == GameStage.awakening.
  final int beatIndex;

  /// Индекс страницы внутри текущего такта (если реплика была разбита
  /// на несколько страниц). Тоже имеет смысл только для awakening.
  final int pageIndex;

  Map<String, dynamic> toJson() => {
        'stage': stage.name,
        'beat_index': beatIndex,
        'page_index': pageIndex,
      };

  factory GameProgress.fromJson(Map<String, dynamic> json) => GameProgress(
        stage: GameStage.values.firstWhere(
          (s) => s.name == json['stage'],
          orElse: () => GameStage.mainMenu,
        ),
        beatIndex: json['beat_index'] as int? ?? 0,
        pageIndex: json['page_index'] as int? ?? 0,
      );
}
