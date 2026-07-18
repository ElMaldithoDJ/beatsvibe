import 'package:audio_service/audio_service.dart';
import 'package:beatsvibe/routes.dart';
import 'package:beatsvibe/service/audio_handler.dart';
import 'package:beatsvibe/theme.dart';
import 'package:beatsvibe/variables.dart';
import 'package:beatsvibe/vm/audio_vm.dart';
import 'package:beatsvibe/vm/favorites_vm.dart';
import 'package:beatsvibe/vm/player_vm.dart';
import 'package:beatsvibe/vm/playlist_vm.dart';
import 'package:beatsvibe/vm/settings_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  globalAudioHandler = await AudioService.init(
    builder: () => AudioHandlerService(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: "com.beatsvibe.mandril.channel.audio",
      androidNotificationChannelName: 'Music Playback',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
  await Hive.initFlutter();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const BeatsVibe());
}

class BeatsVibe extends StatefulWidget {
  const BeatsVibe({super.key});

  @override
  State<BeatsVibe> createState() => _BeatsVibeState();
}

class _BeatsVibeState extends State<BeatsVibe> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioViewModel()),
        ChangeNotifierProvider(create: (_) => FavoritesViewModel()),
        ChangeNotifierProvider(create: (_) => PlayerViewModel()),
        ChangeNotifierProvider(create: (_) => PlaylistViewModel()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (context, settingsViewModel, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppVariables.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsViewModel.themeMode,
            initialRoute: AppRoutes.splash,
            getPages: AppRoutes.pages,
            
          );
        },
      ),
    );
  }
}
