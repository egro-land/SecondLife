import 'package:audioplayers/audioplayers.dart';
import '../settings/app_settings.dart';

/// Сервис фоновой музыки — синглтон, чтобы музыка не прерывалась
/// и не запускалась заново при переходах между экранами.
///
/// Автоматически следит за AppSettings.instance.musicVolume —
/// как только пользователь двигает ползунок в настройках,
/// громкость трека меняется сразу же, без перезапуска.
class BackgroundMusicService {
  BackgroundMusicService._internal() {
    AppSettings.instance.musicVolume.addListener(_onVolumeChanged);
    _configureAudioContext();
  }

  static final BackgroundMusicService instance =
      BackgroundMusicService._internal();

  final AudioPlayer _player = AudioPlayer();
  String? _currentAsset;

  /// Говорим системе, что этот плеер не должен "бороться" за аудио-фокус
  /// с видео (или любым другим звуком в приложении) — тогда музыка
  /// не будет обрываться системой сама по себе. Останавливаем/запускаем
  /// её мы теперь сами явно (pause/resume), под конкретные экраны.
  Future<void> _configureAudioContext() async {
    await _player.setAudioContext(
      AudioContext(
        android: AudioContextAndroid(
          isSpeakerphoneOn: false,
          stayAwake: false,
          contentType: AndroidContentType.music,
          usageType: AndroidUsageType.game,
          audioFocus: AndroidAudioFocus.none,
        ),
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.ambient,
          options: {AVAudioSessionOptions.mixWithOthers},
        ),
      ),
    );
  }

  /// Запускает музыку по кругу. Если этот же трек уже играет — ничего
  /// не делает (не перезапускает), чтобы не было щелчка при пересборке
  /// экрана (hot reload, возврат с другого экрана и т.д.)
  Future<void> playLoop(String assetPath) async {
    if (_currentAsset == assetPath) return;
    _currentAsset = assetPath;

    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(AppSettings.instance.musicVolume.value);
    await _player.play(AssetSource(assetPath));
  }

  /// Ставит музыку на паузу (для экранов, где её быть не должно —
  /// видео открытия книги, пролог и т.д.)
  Future<void> pause() => _player.pause();

  /// Возобновляет с того же места, где остановилась (для главного меню)
  Future<void> resume() => _player.resume();

  /// Подстраховка на случай, если resume() почему-то не сработал —
  /// проверяет реальное состояние плеера и досылает play при необходимости.
  Future<void> ensurePlaying() async {
    if (_currentAsset == null) return;
    if (_player.state != PlayerState.playing) {
      await _player.resume();
    }
  }

  Future<void> stop() async {
    await _player.stop();
    _currentAsset = null;
  }

  void _onVolumeChanged() {
    _player.setVolume(AppSettings.instance.musicVolume.value);
  }

  void dispose() {
    AppSettings.instance.musicVolume.removeListener(_onVolumeChanged);
    _player.dispose();
  }
}
