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

late AudioViewModel globalAudioViewModel;

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
    final songs = _hiveService.getAllSongs();
    if ((await songs).isNotEmpty) {
      await songs
          .then((data) {
            data.sort(
              (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
            );
            _songs = data;
            _songsCopy = data;
            notifyListeners();
          })
          .whenComplete(() {
            _setLoadingState(false);
          });
    }
  }

  Future<void> fetchSongs() async {
    String id;
    bool isIncluded;

    FilePicker.platform
        .getDirectoryPath(
          dialogTitle: 'Selecciona una carpeta de música',
          initialDirectory: '/storage/emulated/0/',
        )
        .then((dir) async {
          if (dir != null) {
            _setLoadingState(true);
            final RootIsolateToken? token = RootIsolateToken.instance;
            if (token == null) return;

            final Directory appDocDir =
                await getApplicationDocumentsDirectory();

            StorageIsolateModel model = StorageIsolateModel(
              path: dir,
              token: token,
              appDocDir: appDocDir.path,
            );

            try {
              await compute(scanFiles, model)
                  .then((data) async {
                    final existingFolders = await _hiveService.getFilesFolder();
                    do {
                      id = IDGenerator.generateId(length: 25);
                      isIncluded = existingFolders.any((e) => e.id == id);
                    } while (isIncluded);

                    final folder = FoldersModel(
                      id: id,
                      name: dir.split('/').last,
                      path: dir,
                      items: data.length,
                    );
                    await _hiveService.saveFilesFolder([folder]);
                    await _hiveService.saveAllSongs(data);
                  })
                  .whenComplete(() {
                    _setLoadingState(false);
                    onInit();
                  });
            } catch (_) {
              _setLoadingState(false);
              return;
            }
          }
        });
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
