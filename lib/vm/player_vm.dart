import 'package:audio_service/audio_service.dart';
import 'package:beatsvibe/models/mediaitem_data.dart';
import 'package:beatsvibe/service/audio_handler.dart';
import 'package:beatsvibe/service/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    final songs = await _getSongs();
    final lastPlayedData = await _hiveService.getLastPlayed();
    if (lastPlayedData != null) {
      _lastPlayed = lastPlayedData.toMediaItem();
      notifyListeners();
      await audioHandler.jumpToQueueItem(
        songs.indexWhere((e) => e.id == lastPlayedData.id),
      );
    }

    if (songs.isNotEmpty) {
      await audioHandler.initPlayer(songs: songs);
      _queue = songs;
      notifyListeners();
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
    await audioHandler.skipToNext();
  }

  //back
  void skipToPrevious() async {
    await audioHandler.skipToPrevious();
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

  // like song event
  Future<void> likeSong(MediaItemData? song) async {
    if (song != null) {
      final isFavorite = await _hiveService.isFavorite(song.id);
      if (isFavorite) {
        await _hiveService.removeFavoriteSong(song).whenComplete(() {
          _isFavorite = false;
          notifyListeners();
        });
      } else {
        await _hiveService.addFavoriteSong(song).whenComplete(() {
          _isFavorite = true;
          notifyListeners();
          Fluttertoast.showToast(
            msg: "Canción agregada a favoritos",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        });
      }
    } else {
      if (currentItem != null) {
        final songData = MediaItemData.fromMediaItem(currentItem);
        if (songData != null) {
          final isFavorite = await _hiveService.isFavorite(songData.id);
          if (isFavorite) {
            await _hiveService.removeFavoriteSong(songData).whenComplete(() {
              _isFavorite = false;
              notifyListeners();
            });
          } else {
            await _hiveService.addFavoriteSong(songData).whenComplete(() {
              _isFavorite = true;
              notifyListeners();
              Fluttertoast.showToast(
                msg: "Canción agregada a favoritos",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.pink,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            });
          }
        }
      }
    }
  }

  // add To favorite
  void addToFavorite(MediaItemData song) async {
    await _hiveService.addFavoriteSong(song);
    notifyListeners();
  }

  // remove from favorite
  void removeFromFavorite(MediaItemData song) async {
    await _hiveService.removeFavoriteSong(song);
    notifyListeners();
  }

  Future<List<MediaItemData>> _getSongs() async {
    return await _hiveService.getAllSongs();
  }
}
