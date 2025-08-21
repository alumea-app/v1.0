import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// A simple provider for our new service
final audioPlayerServiceProvider = Provider((ref) => AudioPlayerService());

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Stream<Duration> get onPositionChanged => _audioPlayer.onPositionChanged;
  Stream<Duration> get onDurationChanged => _audioPlayer.onDurationChanged;
  Stream<PlayerState> get onPlayerStateChanged => _audioPlayer.onPlayerStateChanged;

  Future<void> play(String assetPath) async {
    await _audioPlayer.play(AssetSource(assetPath));
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}