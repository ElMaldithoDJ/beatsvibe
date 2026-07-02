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
    final songs = _getSongs();
    if ((await songs).isNotEmpty) {
      await songs.then((data){
        data.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        _queue = data;
        notifyListeners();
        audioHandler.initPlayer(songs: _queue);
      });
    }
    final lastPlayedData = await _hiveService.getLastPlayed();
    if (lastPlayedData != null) {
      _lastPlayed = lastPlayedData.toMediaItem();
      notifyListeners();
      await audioHandler.jumpToQueueItem(
        _queue.indexWhere((e) => e.id == _lastPlayed?.id),
      );
    }
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
    audioHandler.mediaItem.listen((mediaItem) async {
      if (mediaItem != null) {
        _lastPlayed = mediaItem;
        _isFavorite = await _hiveService.isFavorite(mediaItem.id);
        notifyListeners();
        final mediaItemData = MediaItemData.fromMediaItem(mediaItem);
        if (mediaItemData != null) {
          await _hiveService.saveLastPlayed(mediaItemData);
        }
      }
    });
  }

  //Play
  Future<void> play(int? index, {List<MediaItemData>? playlist}) async {
    if (playlist != null) {
      bool isSame = false;
      if (audioHandler.queue.value.length == playlist.length) {
        isSame = true;
        for (int i = 0; i < playlist.length; i++) {
          if (audioHandler.queue.value[i].id != playlist[i].id.toString()) {
            isSame = false;
            break;
          }
        }
      }
      if (!isSame) {
        await audioHandler.initPlayer(songs: playlist);
      }
    } else {
      final songs = await _getSongs();
      if (audioHandler.queue.value.length != songs.length) {
        await audioHandler.initPlayer(songs: songs);
      }
    }

    if (index != null) {
      await audioHandler.skipToQueueItem(index);
    }
    await audioHandler.play();
    notifyListeners();
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
    final index = globalAudioHandler.queue.value.length - 1;
    if (globalAudioHandler.player.currentIndex! < index) {
      await audioHandler.skipToNext();
    } else if (globalAudioHandler.player.currentIndex == index) {
      await audioHandler.skipToQueueItem(0);
    }
  }

  //back
  void skipToPrevious() async {
    final index = globalAudioHandler.queue.value.length - 1;
    if (globalAudioHandler.player.currentIndex! > 0) {
      await audioHandler.skipToPrevious();
    } else if (globalAudioHandler.player.currentIndex == 0) {
      await audioHandler.skipToQueueItem(index);
    }
  }

  //shuffle
  void setShuffle() {
    audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
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
