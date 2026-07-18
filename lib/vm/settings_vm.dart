import 'dart:io';
import 'dart:ui' show RootIsolateToken;

import 'package:beatsvibe/models/folders_model.dart';
import 'package:beatsvibe/models/settings_opt.dart';
import 'package:beatsvibe/models/storage_isolate_model.dart';
import 'package:beatsvibe/routes.dart';
import 'package:beatsvibe/service/fetch_audio_service.dart';
import 'package:beatsvibe/service/hive_service.dart';
import 'package:beatsvibe/util/id_generator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SettingsViewModel extends ChangeNotifier {
  final HiveService _hiveService = HiveService();
  ThemeMode _themeMode = ThemeMode.system;
  bool _isLoading = false;
  
  ThemeMode get themeMode => _themeMode;
  bool get isLoading => _isLoading;

  List<SettingsOptionsModel> _settingsOptions = [
    SettingsOptionsModel(
      title: 'Apariencia',
      subtitle: 'Cambiar el tema',
      icon: CupertinoIcons.paintbrush_fill,
      route: AppRoutes.appearanceSettings,
    ),
    SettingsOptionsModel(
      title: 'Reproductor',
      subtitle: 'Configuraciones del reproductor',
      icon: CupertinoIcons.play_circle_fill,
      route: AppRoutes.playerSettings,
    ),
    SettingsOptionsModel(
      title: 'Idioma',
      subtitle: 'Configuraciones de idioma (Inglés/Español)',
      icon: CupertinoIcons.globe,
      route: AppRoutes.languageSettings,
    ),
    SettingsOptionsModel(
      title: 'Privacidad',
      subtitle: 'Configuraciones de privacidad',
      icon: CupertinoIcons.shield,
      route: AppRoutes.privacySettings,
    ),
    SettingsOptionsModel(
      title: 'Acerca de',
      subtitle: 'Información de la aplicación',
      icon: CupertinoIcons.info_circle_fill,
      route: AppRoutes.aboutSettings,
    ),
  ];

  List<FoldersModel> _folderPath = [];

  List<SettingsOptionsModel> get settingsOptions => _settingsOptions;
  List<FoldersModel> get folderPath => _folderPath;

  SettingsViewModel() {
    _init();
  }

  void _init() async {
    await initFolder();
  }

  Future<void> initFolder() async {
    await _hiveService.getFilesFolder().then((value) {
      _folderPath = value;
      notifyListeners();
    });
  }

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  Future<void> addFolder() async {
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
                    initFolder();
                  });
            } catch (_) {
              _setLoadingState(false);
              return;
            }
          }
        });
  }

  void _setLoadingState(bool state) {
    _isLoading = state;
    notifyListeners();
  }

  // Delete folder
  Future<void> deleteFolder(String id) async {
    await _hiveService.removeFilesFolder(id);
    await initFolder();
  }
}
