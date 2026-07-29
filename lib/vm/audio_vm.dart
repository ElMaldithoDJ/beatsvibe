import 'dart:async';
import 'dart:io' show Directory;

import 'package:beatsvibe/models/folders_model.dart';
import 'package:beatsvibe/models/mediaitem_data.dart';
import 'package:beatsvibe/models/storage_isolate_model.dart';
import 'package:beatsvibe/service/fetch_audio_service.dart';
import 'package:beatsvibe/service/hive_service.dart';
import 'package:beatsvibe/util/id_generator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:string_normalizer/string_normalizer.dart';

class AudioViewModel extends ChangeNotifier {
  final HiveService _hiveService = HiveService();
  int _tabIndex = 0;

  bool _isLoading = false;
  List<MediaItemData> _songs = [];
  List<MediaItemData> _songsCopy = [];
  List<MediaItemData> _songsSelected = [];

  bool get isLoading => _isLoading;
  List<MediaItemData> get songs => _songs;
  List<MediaItemData> get songsCopy => _songsCopy;
  List<MediaItemData> get songsSelected => _songsSelected;
  int get tabIndex => _tabIndex;

  AudioViewModel() {
    onInit();
  }

  Future<void> onInit() async {
    final data = await _hiveService.getAllSongs();
    if (data.isNotEmpty) {
      data.sort(
        (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      );
      _songs = data;
      _songsCopy = data;
      notifyListeners();
    } else {
      _songs = [];
      _songsCopy = [];
      notifyListeners();
    }
    _setLoadingState(false);
  }

  Future<void> fetchSongs() async {
    String id;
    bool isIncluded;

    final dir = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Selecciona una carpeta de música',
      initialDirectory: '/storage/emulated/0/',
    );

    if (dir != null) {
      _setLoadingState(true);
      final RootIsolateToken? token = RootIsolateToken.instance;
      if (token == null) {
        _setLoadingState(false);
        return;
      }

      final Directory appDocDir = await getApplicationDocumentsDirectory();

      StorageIsolateModel model = StorageIsolateModel(
        path: dir,
        token: token,
        appDocDir: appDocDir.path,
      );

      try {
        final data = await compute(scanFiles, model);
        final existingFolders = await _hiveService.getFilesFolder();
        do {
          id = IDGenerator.generateId(length: 25);
          isIncluded = existingFolders.any((e) => e.id == id);
        } while (isIncluded);

        final folder = FoldersModel(
          id: id,
          name: dir.split('/').last,
          path: dir,
          items: [
            ...data.map((e) => e.id),
          ],
        );
        await _hiveService.saveFilesFolder([folder]);
        await _hiveService.saveAllSongs(data);
      } catch (_) {
        _setLoadingState(false);
        return;
      }

      _setLoadingState(false);
      onInit();
    }
  }

  void onSearch(String query) {
    if (query.isEmpty || query == "") {
      _songs = _songsCopy;
      notifyListeners();
    } else {
      final q = StringNormalizer.normalize(query.toLowerCase());
      _songs = _songsCopy.where((song) {
        return StringNormalizer.normalize(song.title.toLowerCase())
                .indexOf(q) >=
            0;
      }).toList();
    }
    notifyListeners();
  }

  void _setLoadingState(bool state) {
    _isLoading = state;
    notifyListeners();
  }

  void selectSong(String id) {
    if (_songsSelected.any((e) => e.id == id)) {
      _songsSelected.removeWhere((e) => e.id == id);
    } else {
      _songsSelected.add(_songsCopy.firstWhere((e) => e.id == id));
    }
    notifyListeners();
  }

  bool isSongSelected(String id) {
    return _songsSelected.any((e) => e.id == id);
  }
}
