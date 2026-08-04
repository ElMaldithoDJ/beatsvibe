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
    _setLoadingState(true);
    _hiveService
        .getAllSongs()
        .then((data) {
          if (data.isNotEmpty) {
            data.sort(
              (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
            );
            _songs = data;
            _songsCopy = data;
            notifyListeners();
          }
        })
        .whenComplete(() async {
          _setLoadingState(false);
          final folders = await _hiveService.getFilesFolder();
          if (folders.isNotEmpty) {
            for (FoldersModel folder in folders) {
              final files = Directory(folder.path!).listSync();
              if (folder.items!.length < files.length) {
                updateMusic(folder);
              }
            }
          }
        });
  }

  Future<void> fetchSongs() async {
    String id;
    bool isIncluded;

    final dir = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Selecciona una carpeta',
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
          items: [...data.map((e) => e.id)],
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

  void updateMusic(FoldersModel folder) async {
    _setLoadingState(true);
    bool isIncluded;
    String songId;
    final allExistingSongs = [..._songsCopy];
    final Directory appDocDir = await getApplicationDocumentsDirectory();

    bool hasChanges = false;

    final RootIsolateToken? token = RootIsolateToken.instance;
      if (token == null) {
        _setLoadingState(false);
        return;
      }
      StorageIsolateModel model = StorageIsolateModel(
        path: folder.path!,
        token: token,
        appDocDir: appDocDir.path,
      );

      try {
        final scannedData = await compute(scanFiles, model);

        List<String> updatedFolderItems = folder.items ?? [];
        List<MediaItemData> songsToSave = [];

        for (var scannedSong in scannedData) {
          bool exists = allExistingSongs.any(
            (e) => e.title == scannedSong.title,
          );
          if (!exists) {
            hasChanges = true;
            do {
              songId = IDGenerator.generateId(length: 25);
              isIncluded = allExistingSongs.any((e) => e.id == songId);
            } while (isIncluded);
            final newSong = MediaItemData(
              id: songId,
              title: scannedSong.title,
              audioUrl: scannedSong.audioUrl,
              artist: scannedSong.artist,
              album: scannedSong.album,
              genre: scannedSong.genre,
              artUri: scannedSong.artUri,
              duration: scannedSong.duration,
              format: scannedSong.format,
              bitrate: scannedSong.bitrate,
            );
            songsToSave.addAll([...songsCopy, newSong]);
            updatedFolderItems.add(songId);
          }
        }
        await _hiveService.saveAllSongs(songsToSave);

        final updatedFolder = FoldersModel(
          id: folder.id,
          name: folder.name,
          path: folder.path,
          items: updatedFolderItems,
        );
        await _hiveService.updateFilesFolder(updatedFolder);
      } catch (_) {
        _setLoadingState(false);
        return;
      }

    if (hasChanges) {
      final updatedSongs = await _hiveService.getAllSongs();
      if (updatedSongs.isNotEmpty) {
        updatedSongs.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        _songs = updatedSongs;
        _songsCopy = updatedSongs;
        notifyListeners();
      }
    }

    _setLoadingState(false);
  }
}
