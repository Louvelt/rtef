import 'package:radio_player/radio_player.dart';

class AudioPlayerHelper {
  static final AudioPlayerHelper _instance = AudioPlayerHelper._internal();
  factory AudioPlayerHelper() => _instance;
  AudioPlayerHelper._internal();

  bool isPlaying = false;

  Future<void> play({
    required String url,
    required String title,
    String? imagePath,
  }) async {
    try {
      print('[AudioPlayerHelper] Attempting to play radio...');
      await RadioPlayer.setStation(
        title: title,
        url: url,
        logoAssetPath: imagePath,
      );
      await RadioPlayer.play();
      print('[AudioPlayerHelper] Radio started successfully.');
      isPlaying = true;
    } catch (e) {
      print("Error playing audio: $e");
      isPlaying = false;
    }
  }

  Future<void> pause() async {
    try {
      await RadioPlayer.pause();
      isPlaying = false;
    } catch (e) {
      print("Error pausing audio: $e");
    }
  }

  Future<void> stop() async {
    try {
      await RadioPlayer.pause();
      isPlaying = false;
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }

  void handleMetadataEvents() {
    // Metadata events handling is not directly provided by the radio_player package
    // Please refer to the package documentation for the correct way to handle metadata events
  }

  Stream<Metadata> get metadataStream => RadioPlayer.metadataStream;
  Stream<PlaybackState> get stateStream => RadioPlayer.playbackStateStream;
}
