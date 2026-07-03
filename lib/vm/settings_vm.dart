import 'package:beatsvibe/models/settings_opt.dart';
import 'package:beatsvibe/routes.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';

class SettingsViewModel extends ChangeNotifier {
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

  List<SettingsOptionsModel> get settingsOptions => _settingsOptions;

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  
}