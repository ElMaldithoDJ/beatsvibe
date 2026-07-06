import 'package:audio_service/audio_service.dart';
import 'package:beatsvibe/models/mediaitem_data.dart';
import 'package:beatsvibe/service/audio_handler.dart';
import 'package:beatsvibe/service/hive_service.dart';
import 'package:flutter/material.dart';

class PlayerViewModel extends ChangeNotifier {
  final _hiveService = HiveService();
  final audioHandler = globalAudioHandler;

  bool _isPlaying = false;
  bool _isFavorite = false;
  MediaItem? _lastPlayed;
  AudioServiceRepeatMode _repeatMode = AudioServiceRepeatMode.none;
  Duration _currentPosition = Duration.zero;
  Duration _duration = Duration.zero;
  List<MediaItemData> _queue = [];

  bool get isPlaying => _isPlaying;
  bool get isFavorite => _isFavorite;
  MediaItem? get lastPlayed => _lastPlayed;
  Duration get duration => _duration;
  List<MediaItemData> get queue => _queue;
  AudioServiceRepeatMode get repeatMode => _repeatMode;

  MediaItem? get currentItem {
    if (_lastPlayed != null) {
      return _lastPlayed;
    } else {
      return audioHandler.mediaItem.value;
    }
  }

  String get currentPositionString {
    final int minutes = _currentPosition.inMinutes;
    final int seconds = _currentPosition.inSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  String get durationString {
    final int minutes = _duration.inMinutes;
    final int seconds = _duration.inSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  double get progress {
    if (_duration == Duration.zero) return 0.0;
    return _currentPosition.inMilliseconds / _duration.inMilliseconds;
  }

  PlayerViewModel() {
    onInit();
  }

  void onInit() async {
    await _listenLastPlayedSong();
    _listenQueue();
    _listenCurrentItem();

    audioHandler.playbackState.listen((state) {
      _playingState(state.playing);
    });
    audioHandler.positionStream.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });
    audioHandler.durationStream.listen((duration) {
      if (duration != null) {
        _duration = duration;
        notifyListeners();
      }
    });
  }

  // Iniciar Streams de cola
  void _listenQueue() {
    audioHandler.queue.listen((dataQueue) {
      if (dataQueue.isNotEmpty) {
        _queue = dataQueue.map((e) => MediaItemData.fromMediaItem(e)!).toList();
        notifyListeners();
      }
    });
  }

  // Iniciar stream de ultima cancion reproducida
  Future<void> _listenLastPlayedSong() async {
    await _hiveService
        .getLastPlayed()
        .then((lastPlayedData) {
          if (lastPlayedData != null) {
            _lastPlayed = lastPlayedData.toMediaItem();
            notifyListeners();
          }
        })
        .whenComplete(() async {
          await audioHandler.jumpToQueueItem(
            _queue.indexWhere((e) => e.id == currentItem?.id),
          );
        });
  }

  // Iniciar Stream de cancion actual
  void _listenCurrentItem() async {
    audioHandler.mediaItem.listen((mediaItem) async {
      if (mediaItem != null) {
        _lastPlayed = mediaItem;
        notifyListeners();
        _isFavorite = await _hiveService.isFavorite(mediaItem.id);
        final mediaItemData = MediaItemData.fromMediaItem(mediaItem);
        if (mediaItemData != null && mediaItemData.id != lastPlayed?.id) {
          await _hiveService.saveLastPlayed(mediaItemData);
        }
      }
    });
  }

  //Play
  Future<void> play({
    MediaItemData? song,
    List<MediaItemData>? playlist,
  }) async {
    try {
      if (playlist != null) {
        await audioHandler.initPlayer(songs: playlist);
        if (song != null) {
          await audioHandler.skipToQueueItem(
            playlist.indexWhere((e) => e.id == song.id),
          );
        }
      } else if (song != null) {
        await audioHandler.skipToQueueItem(
          _queue.indexWhere((e) => e.id == song.id),
        );
      }
      await audioHandler.play();
    } catch (e) {
      skipToNext();
    }
  }

  //pause
  void pause() {
    audioHandler.pause();
  }

  //seek
  void seek(Duration duration) {
    audioHandler.seek(duration);
  }

  //skip
  void skipToNext() async {
    final index = audioHandler.queue.value.length - 1;
    if (audioHandler.player.currentIndex! < index) {
      await audioHandler.skipToNext();
    } else if (audioHandler.player.currentIndex == index) {
      await audioHandler.skipToQueueItem(0);
    }
  }

  //back
  void skipToPrevious() async {
    final index = audioHandler.queue.value.length - 1;
    if (audioHandler.player.currentIndex! > 0) {
      await audioHandler.skipToPrevious();
    } else if (audioHandler.player.currentIndex == 0) {
      await audioHandler.skipToQueueItem(index);
    }
  }

  //shuffle
  void setRepeatMode() async {
    if (_repeatMode == AudioServiceRepeatMode.none) {
      _repeatMode = AudioServiceRepeatMode.all;
      notifyListeners();
      await audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
    } else if (_repeatMode == AudioServiceRepeatMode.all) {
      _repeatMode = AudioServiceRepeatMode.one;
      notifyListeners();
      await audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
    } else {
      _repeatMode = AudioServiceRepeatMode.none;
      notifyListeners();
      await audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
    }
  }

  // Playing State
  void _playingState(bool state) {
    _isPlaying = state;
    notifyListeners();
  }

  // Delete song
  Future<void> deleteSong(String id) async {
    await _hiveService.deleteSong(id);
    if (currentItem?.id == id) {
      //remove current item from queue
      _queue.removeWhere((e) => e.id == id);
      audioHandler.queue.value.removeWhere((e) => e.id == id);
      skipToNext();
      notifyListeners();
    } else {
      //remove current item from queue
      _queue.removeWhere((e) => e.id == id);
      audioHandler.queue.value.removeWhere((e) => e.id == id);
      notifyListeners();
    }
  }
}
