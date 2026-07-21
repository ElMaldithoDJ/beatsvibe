import 'package:audio_service/audio_service.dart';
import 'package:beatsvibe/models/lastplayed_model.dart';
import 'package:beatsvibe/models/mediaitem_data.dart';
import 'package:beatsvibe/models/playlist_data.dart';
import 'package:beatsvibe/service/audio_handler.dart';
import 'package:beatsvibe/service/hive_service.dart';
import 'package:flutter/material.dart';

class PlayerViewModel extends ChangeNotifier {
  final _hiveService = HiveService();
  final audioHandler = globalAudioHandler;

  bool _isPlaying = false;
  bool _isFavorite = false;
  MediaItem? _lastPlayed;
  AudioServiceRepeatMode _repeatMode = AudioServiceRepeatMode.all;
  Duration _currentPosition = Duration.zero;
  Duration _duration = Duration.zero;

  bool get isPlaying => _isPlaying;
  bool get isFavorite => _isFavorite;
  MediaItem? get lastPlayed => _lastPlayed;
  Duration get duration => _duration;
  List<MediaItemData>? get queue {
    if (audioHandler.queue.value.isNotEmpty) {
      return audioHandler.queue.value
          .map((e) => MediaItemData.fromMediaItem(e)!)
          .toList();
    }
    return null;
  }

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

  bool _shouldPlay = false;

  PlayerViewModel() {
    onInit();
  }

  void onInit() async {
    _listenCurrentItem();
    await _loadLastPlayedPlaylist();
    _listenQueue();
    _listenPosition();
    _listenPlaybackState();
    _listenCompleted();
    audioHandler.durationStream.listen((duration) {
      if (duration != null) {
        _duration = duration;
        notifyListeners();
      }
    });
  }

  void _listenPlaybackState() {
    try {
      audioHandler.playbackState.listen((playbackState) {
        final playing = playbackState.playing;
        if (_isPlaying != playing) {
          _isPlaying = playing;
          notifyListeners();
        }
      });
    } catch (e) {
      debugPrint("Error al iniciar stream de playbackState: ${e.toString()}");
    }
  }

  void _listenCompleted() {
    try {
      audioHandler.playbackState.listen((playbackState) {
        if (playbackState.processingState ==
            AudioProcessingState.completed) {
          skipToNext();
        }
        if (playbackState.processingState == AudioProcessingState.idle) {
          _resetPlayer();
        }
      });
    } catch (e) {
      debugPrint("Error al iniciar stream de completed: ${e.toString()}");
    }
  }

  void _loadSongs() {
    try {
      _hiveService.getAllSongs().then((songs) async {
        if (songs.isNotEmpty) {
          await audioHandler.initPlayer(songs: songs);
        }
      });
    } catch (e) {
      debugPrint("Error al cargar canciones: ${e.toString()}");
    }
  }

  Future<void> _loadLastPlayedPlaylist() async {
    try {
      _hiveService.getLastPlayedPlaylist().then((lastPlayedPlaylist) async {
        if (lastPlayedPlaylist != null) {
          await audioHandler
              .initPlayer(songs: lastPlayedPlaylist.songs!)
              .whenComplete(() async {
                final lastPlayedData = await _hiveService.getLastPlayed();
                if (lastPlayedData != null) {
                  await audioHandler
                      .jumpToQueueItem(
                        queue!.indexWhere((e) => e.id == lastPlayedData.id),
                      )
                      .whenComplete(() {
                        seek(Duration(seconds: lastPlayedData.position!));
                      });
                }
              });
        } else {
          _loadSongs();
        }
      });
    } catch (e) {
      debugPrint(
        "Error al cargar la ultima lista de reproduccion: ${e.toString()}",
      );
    }
  }

  // Iniciar Stream de cancion actual
  void _listenCurrentItem() async {
    try {
      audioHandler.mediaItem.listen((mediaItem) async {
        if (mediaItem != null) {
          _lastPlayed = mediaItem;
          _isFavorite = await _hiveService.isFavorite(mediaItem.id);
          notifyListeners();
        }
      });
    } catch (e) {
      debugPrint("Error al iniciar stream de cancion actual: ${e.toString()}");
    }
  }

  // Iniciar stream de la cola actual
  void _listenQueue() async {
    try {
      audioHandler.queue.listen((queue) async {
        if (queue.isNotEmpty) {
          await _hiveService.saveLastPlayedPlaylist(
            PlaylistModelData(
              songs: queue.map((e) => MediaItemData.fromMediaItem(e)!).toList(),
            ),
          );
        }
      });
    } catch (e) {
      debugPrint("Error al iniciar stream de cola actual: ${e.toString()}");
    }
  }

  void _listenPosition() {
    try {
      audioHandler.positionStream.listen((p) async {
        _currentPosition = p;
        notifyListeners();
        if (isPlaying && p.inSeconds > 0) {
          await _hiveService.saveLastPlayed(
            LastPlayedModel(id: currentItem?.id, position: p.inSeconds),
          );
        }
      });
    } catch (e) {
      debugPrint("Error al iniciar stream de posicion: ${e.toString()}");
    }
  }

  //Play
  Future<void> play({
    MediaItemData? song,
    List<MediaItemData>? playlist,
  }) async {
    _shouldPlay = true;
    try {
      if (playlist != null) {
        await audioHandler.initPlayer(songs: playlist);
        if (!_shouldPlay) return;
        if (song != null) {
          await audioHandler.skipToQueueItem(
            playlist.indexWhere((e) => e.id == song.id),
          );
          if (!_shouldPlay) return;
        }
      }
      if (_shouldPlay) {
        await audioHandler.play();
      }
    } catch (_) {}
  }

  //pause
  void pause() {
    _shouldPlay = false;
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

  // repeat mode
  void setRepeatMode() {
    if (_repeatMode == AudioServiceRepeatMode.all) {
      _repeatMode = AudioServiceRepeatMode.one;
      notifyListeners();
      audioHandler.setPlayerRepeatMode(AudioServiceRepeatMode.one);
    } else if (_repeatMode == AudioServiceRepeatMode.one) {
      _repeatMode = AudioServiceRepeatMode.all;
      notifyListeners();
      audioHandler.setPlayerRepeatMode(AudioServiceRepeatMode.all);
    } else {
      _repeatMode = AudioServiceRepeatMode.none;
      notifyListeners();
      audioHandler.setPlayerRepeatMode(AudioServiceRepeatMode.group);
    }
  }

  // Delete song
  Future<void> deleteSong(String id) async {
    await _hiveService.deleteSong(id);
    if (currentItem?.id == id) {
      //remove current item from queue
      queue?.removeWhere((e) => e.id == id);
      audioHandler.queue.value.removeWhere((e) => e.id == id);
      skipToNext();
      notifyListeners();
    } else {
      //remove current item from queue
      audioHandler.queue.value.removeWhere((e) => e.id == id);
      notifyListeners();
    }
  }

  // Remove deleted songs from queue
  Future<void> removeDeletedSongsFromQueue() async {
    final songs = await _hiveService.getAllSongs();
    final songIds = songs.map((e) => e.id).toSet();
    
    final currentQueue = audioHandler.queue.value.toList();
    currentQueue.removeWhere((item) => !songIds.contains(item.id));
    
    audioHandler.queue.value.clear();
    audioHandler.queue.value.addAll(currentQueue);
    
    if (currentItem != null && !songIds.contains(currentItem!.id)) {
      if (currentQueue.isNotEmpty) {
        skipToNext();
      } else {
        _resetPlayer();
      }
    }
    notifyListeners();
  }

  // save last playlist
  Future<void> saveLastPlaylist(PlaylistModelData playlist) async {
    await _hiveService.saveLastPlayedPlaylist(playlist);
  }

  void _resetPlayer() {
    _currentPosition = Duration.zero;
    _duration = Duration.zero;
    _isPlaying = false;
    _shouldPlay = false;
    notifyListeners();
  }

  @override
  void dispose() {
    audioHandler.mediaItem.close();
    audioHandler.queue.close();
    audioHandler.playbackState.close();
    super.dispose();
  }
}
