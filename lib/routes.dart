import 'package:beatsvibe/components/about_component.dart';
import 'package:beatsvibe/components/dialog_playlist_form.dart';
import 'package:beatsvibe/components/song_selector.dart';
import 'package:beatsvibe/splash.dart';
import 'package:beatsvibe/views/home/home.dart';
import 'package:beatsvibe/views/player/player_view.dart';
import 'package:beatsvibe/views/playlist/playlist_view.dart';
import 'package:beatsvibe/views/settings/appearance_settings.dart';
import 'package:beatsvibe/views/settings/languague_settings.dart';
import 'package:beatsvibe/views/settings/player_settings.dart';
import 'package:beatsvibe/views/settings/privacy_settings.dart';
import 'package:beatsvibe/views/settings/settings_view.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String home = '/';
  static const String splash = '/splash';
  static const String player = '/player';
  static const String settings = '/settings';
  static const String createPlaylist = '/create_playlist';
  static const String songSelector = '/song_selector';
  static const String playlistView = '/playlist_view';
  static const String appearanceSettings = '/appearance_settings';
  static const String privacySettings = '/privacy_settings';
  static const String aboutSettings = '/about_settings';
  static const String playerSettings = '/player_settings';
  static const String languageSettings = '/language_settings';

  static List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeRoute(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.player,
      page: () => const PlayerView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.createPlaylist,
      page: () => const PlayListFormView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.songSelector,
      page: () => const SongSelector(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.playlistView,
      page: () => PlaylistView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.appearanceSettings,
      page: () => const AppearanceSettingsView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.privacySettings,
      page: () => const PrivacySettingsView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.aboutSettings,
      page: () => const AboutComponent(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.playerSettings,
      page: () => const PlayerSettingsView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.languageSettings,
      page: () => const LanguageSettingsView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
