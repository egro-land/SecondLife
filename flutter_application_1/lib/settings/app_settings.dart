import 'package:flutter/foundation.dart';

/// Глобальные настройки звука.
///
/// Простой синглтон без внешних пакетов (без provider/riverpod),
/// чтобы его было легко воткнуть в любой существующий экран.
///
/// Когда подключите аудио-плеер (например, audioplayers или just_audio),
/// просто слушайте musicVolume/voiceVolume через .addListener(...)
/// и вызывайте player.setVolume(value) при изменении.
class AppSettings {
  AppSettings._internal();

  static final AppSettings instance = AppSettings._internal();

  /// Громкость фоновой музыки, от 0.0 до 1.0
  final ValueNotifier<double> musicVolume = ValueNotifier<double>(0.7);

  /// Громкость голосов персонажей (озвучка реплик), от 0.0 до 1.0
  final ValueNotifier<double> voiceVolume = ValueNotifier<double>(1.0);

  // TODO: когда появится сохранение прогресса — подгрузить/сохранить
  // эти значения через SharedPreferences, чтобы настройки не сбрасывались
  // при перезапуске приложения.
}
