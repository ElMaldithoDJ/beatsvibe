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
  Duration _currentPosition = Duration.zero;
  Duration _duration = Duration.zero;
  List<MediaItemData> _queue = [];

  bool get isPlaying => _isPlaying;
  bool get isFavorite => _isFavorite;
  MediaItem? get currentItem => audioHandler.mediaItem.value;
  MediaItem? get lastPlayed => _lastPlayed;
  Duration get duration => _duration;
  List<MediaItemData> get queue => _queue;
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
    _listenQueue();
    _listenLastPlayedSong();
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
  void _listenLastPlayedSong() async {
    final lastPlayedData = await _hiveService.getLastPlayed();
    if (lastPlayedData != null) {
      _lastPlayed = lastPlayedData.toMediaItem();
      await audioHandler.jumpToQueueItem(
        _queue.indexWhere((e) => e.id == _lastPlayed?.id),
      );
      notifyListeners();
    }
  }

  // Iniciar Stream de cancion actual
  void _listenCurrentItem() async {
    audioHandler.mediaItem.listen((mediaItem) async {
      if (mediaItem != null) {
        _lastPlayed = mediaItem;
        notifyListeners();
        _isFavorite = await _hiveService.isFavorite(mediaItem.id);
        final mediaItemData = MediaItemData.fromMediaItem(mediaItem);
        if (mediaItemData != null) {
          await _hiveService.saveLastPlayed(mediaItemData);
        }
      }
    });
  }

  //Play
  Future<void> play(
    MediaItemData? song, {
    List<MediaItemData>? playlist,
  }) async {
    if (playlist != null) {
      bool isSame = false;
      if (audioHandler.queue.value.length == playlist.length) {
        isSame = true;
        for (int i = 0; i < playlist.length; i++) {
          if (audioHandler.queue.value[i].id != playlist[i].id) {
            isSame = false;
            break;
          }
        }
      }
      if (!isSame) {
        await audioHandler.initPlayer(songs: playlist);
      }
    } else if (song != null) {
      final songs = await _getSongs();
      if (audioHandler.queue.value.length != songs.length) {
        await audioHandler.initPlayer(songs: songs);
      } 
    }

    if (song != null) {
      final index = audioHandler.queue.value.indexWhere((e) => e.id == song.id);
      if (index != -1) {
        await audioHandler.skipToQueueItem(index);
      }
    } else if (lastPlayed != null) {
      final index = audioHandler.queue.value.indexWhere((e) => e.id == lastPlayed!.id);
      if (index != -1) {
        await audioHandler.skipToQueueItem(index);
      }
    }

    await audioHandler.play();
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
  void setShuffle() {
    globalAudioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    notifyListeners();
  }

  // Playing State
  void _playingState(bool state) {
    _isPlaying = state;
    notifyListeners();
  }

  Future<List<MediaItemData>> _getSongs() async {
    return await _hiveService.getAllSongs();
  }
}
