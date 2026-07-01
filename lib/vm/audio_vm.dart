import 'dart:async';

import 'package:beatsvibe/models/mediaitem_data.dart';
import 'package:beatsvibe/service/fetch_audio_service.dart';
import 'package:beatsvibe/service/hive_service.dart';
import 'package:flutter/foundation.dart';

class AudioViewModel extends ChangeNotifier {
  final HiveService _hiveService = HiveService();

  bool _isLoading = false;
  List<MediaItemData> _songs = [];
  List<MediaItemData> _songsCopy = [];

  bool get isLoading => _isLoading;
  List<MediaItemData> get songs => _songs;

  AudioViewModel() {
    onInit();
  }

  Future<void> onInit() async {
    if ((await _hiveService.getAllSongs()).isNotEmpty) {
      await _hiveService
          .getAllSongs()
          .then((data) {
            _songs = data;
            _songsCopy = data;
            notifyListeners();
          })
          .whenComplete(() => _setLoadingState(false));
    }
  }

  Future<void> fetchSongs() async {
    _setLoadingState(true);
    await FetchAudioService.scanLocalFiles().whenComplete(() async {
      await onInit();
      _setLoadingState(false);
    });
  }

  void onSearch(String query) {
    if (query.isEmpty) {
      _songs = _songsCopy;
      notifyListeners();
      return;
    }
    _songs = _songsCopy.where((song) {
      return song.title.toLowerCase().indexOf(query.toLowerCase()) >= 0;
    }).toList();
    notifyListeners();
  }

  void _setLoadingState(bool state) {
    _isLoading = state;
    notifyListeners();
  }
}
