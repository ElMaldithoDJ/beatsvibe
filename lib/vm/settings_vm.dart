import 'package:beatsvibe/models/folders_model.dart';
import 'package:beatsvibe/models/settings_opt.dart';
import 'package:beatsvibe/routes.dart';
import 'package:beatsvibe/service/fetch_audio_service.dart';
import 'package:beatsvibe/service/hive_service.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';

class SettingsViewModel extends ChangeNotifier {
  final HiveService _hiveService = HiveService();
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  final List<SettingsOptionsModel> _settingsOptions = [
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
    await FetchAudioService.scanLocalFiles().whenComplete(() async {
      await initFolder();
    });
  }
}
