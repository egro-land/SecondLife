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
  }

  static final BackgroundMusicService instance =
      BackgroundMusicService._internal();

  final AudioPlayer _player = AudioPlayer();
  String? _currentAsset;

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

  Future<void> stop() async {
    await _player.stop();
    _currentAsset = null;
  }

  Future<void> pause() => _player.pause();

  Future<void> resume() => _player.resume();

  void _onVolumeChanged() {
    _player.setVolume(AppSettings.instance.musicVolume.value);
  }

  void dispose() {
    AppSettings.instance.musicVolume.removeListener(_onVolumeChanged);
    _player.dispose();
  }
}
