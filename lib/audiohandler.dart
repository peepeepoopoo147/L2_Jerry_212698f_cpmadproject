import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

void audioPlayerTaskEntryPoint() {
  AudioServiceBackground.run(() => MyBackgroundTask());
}

class MyBackgroundTask extends BackgroundAudioTask {
  final _player = AudioPlayer();

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    _player.playbackEventStream.listen((event) {
      _setState();
    });
  }

  void _setState() {
    AudioServiceBackground.setState(
      controls: [
        MediaControl.skipToPrevious,
        _player.playing ? MediaControl.pause : MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: [MediaAction.seekTo],
    );
  }

  @override
  Future<void> onPlay() => _player.play();

  @override
  Future<void> onPause() => _player.pause();

  @override
  Future<void> onStop() async {
    await _player.dispose();

    AudioServiceBackground.setState();
    await super.onStop();
  }
}
