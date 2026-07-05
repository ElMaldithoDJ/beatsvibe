import 'dart:async';

import 'package:beatsvibe/models/mediaitem_data.dart';
import 'package:beatsvibe/service/fetch_audio_service.dart';
import 'package:beatsvibe/service/hive_service.dart';
import 'package:flutter/foundation.dart';
import 'package:string_normalizer/string_normalizer.dart';

class AudioViewModel extends ChangeNotifier {
  final HiveService _hiveService = HiveService();

  bool _isLoading = false;
  List<MediaItemData> _songs = [];
  List<MediaItemData> _songsCopy = [];

  bool get isLoading => _isLoading;
  List<MediaItemData> get songs => _songs;
  List<MediaItemData> get songsCopy => _songsCopy;

  AudioViewModel() {
    onInit();
  }

  Future<void> onInit() async {
    final songs = _hiveService.getAllSongs();
    if ((await songs).isNotEmpty) {
          await songs
          .then((data) {
            data.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
            _songs = data;
            _songsCopy = data;
            notifyListeners();
          })
          .whenComplete(() => _setLoadingState(false));
    }
  }

  Future<void> fetchSongs() async {
    _setLoadingState(true);
    await FetchAudioService.scanLocalFiles()
    .then((songs) async {
      await _hiveService.saveAllSongs(songs);
    })
    .whenComplete(() async {
      await onInit();
      _setLoadingState(false);
    });
  }

  void onSearch(String query) {
    if (query.isEmpty || query == "") {
      _songs = _songsCopy;
      notifyListeners();
    } else {
      final q = StringNormalizer.normalize(query.toLowerCase());
      _songs = _songsCopy.where((song) {
        return StringNormalizer.normalize(song.title.toLowerCase()).indexOf(q) >= 0;
      }).toList();
    }
    notifyListeners();
  }

  void _setLoadingState(bool state) {
    _isLoading = state;
    notifyListeners();
  }
}
