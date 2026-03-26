import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../data/workout_music_catalog.dart';

class WorkoutMusicService extends ChangeNotifier {
  WorkoutMusicService._();

  static final WorkoutMusicService instance = WorkoutMusicService._();

  bool _sessionConfigured = false;
  AudioPlayer? _player;

  bool enabled = false;
  int selectedTrackIndex = 0;
  bool playing = false;
  String? lastError;

  Future<void> ensureAudioSession() async {
    if (_sessionConfigured) {
      return;
    }
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    _sessionConfigured = true;
  }

  Future<void> _ensurePlayer() async {
    if (_player != null) {
      return;
    }
    final player = AudioPlayer();
    player.playerStateStream.listen((PlayerState state) {
      playing = state.playing;
      notifyListeners();
    });
    _player = player;
  }

  Future<void> selectTrack(int index) async {
    if (index < 0 || index >= workoutMusicTracks.length) {
      return;
    }
    selectedTrackIndex = index;
    notifyListeners();
    if (enabled) {
      await playCurrentTrack();
    }
  }

  Future<void> playCurrentTrack() async {
    lastError = null;
    await ensureAudioSession();
    await _ensurePlayer();
    final player = _player!;
    final path = workoutMusicTracks[selectedTrackIndex].assetPath;
    try {
      await player.setAudioSource(AudioSource.asset(path));
      await player.setLoopMode(LoopMode.all);
      await player.play();
      enabled = true;
      playing = true;
      notifyListeners();
    } catch (e, st) {
      lastError = e.toString();
      if (kDebugMode) {
        debugPrint('WorkoutMusicService play failed: $e\n$st');
      }
      enabled = false;
      playing = false;
      notifyListeners();
    }
  }

  Future<void> pauseMusic() async {
    final player = _player;
    if (player == null) {
      return;
    }
    await player.pause();
    notifyListeners();
  }

  Future<void> resumeMusic() async {
    if (!enabled) {
      return;
    }
    final player = _player;
    if (player == null) {
      await playCurrentTrack();
      return;
    }
    await player.play();
    notifyListeners();
  }

  Future<void> stopMusic() async {
    enabled = false;
    playing = false;
    lastError = null;
    await _player?.stop();
    notifyListeners();
  }
}
