import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioProgressPlaying {
  AudioProgressPlaying({required this.songUrl});

  final player = AudioPlayer();
  Stream<DurationState>? durationState;
  String songUrl;

  void init() {
    durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
        player.positionStream,
        player.playbackEventStream,
        (position, playBackEvent) => DurationState(
            progress: position,
            buffered: playBackEvent.bufferedPosition,
            total: playBackEvent.duration));
    player.setUrl(songUrl);
  }

  Future<void> dispose(){
    return player.dispose();
  }
}

class DurationState {
  const DurationState({
    required this.progress,
    required this.buffered,
    required this.total,
  });

  final Duration progress;
  final Duration buffered;
  final Duration? total;
}
