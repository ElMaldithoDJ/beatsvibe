import 'package:beatsvibe/components/dialog_playlist_form.dart';
import 'package:beatsvibe/splash.dart';
import 'package:beatsvibe/views/home/home.dart';
import 'package:beatsvibe/views/player/player_view.dart';
import 'package:beatsvibe/views/settings/settings_view.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String home = '/';
  static const String splash = '/splash';
  static const String player = '/player';
  static const String settings = '/settings';
  static const String createPlaylist = '/create_playlist';

  static List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
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
  ];
}
