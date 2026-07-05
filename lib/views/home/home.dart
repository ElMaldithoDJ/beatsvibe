import 'package:beatsvibe/components/audio_player_component.dart';
import 'package:beatsvibe/components/bottom_nav_button.dart';
import 'package:beatsvibe/routes.dart';
import 'package:beatsvibe/variables.dart';
import 'package:beatsvibe/views/home/favorites.dart';
import 'package:beatsvibe/views/home/music.dart';
import 'package:beatsvibe/views/home/playlists.dart';
import 'package:beatsvibe/vm/audio_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> with TickerProviderStateMixin {
  late TabController tabController;

  final List<BottomNavButton> navButtons = [
    BottomNavButton(
      title: "Musica",
      icon: CupertinoIcons.music_note,
      page: const MusicView(),
    ),
    BottomNavButton(
      title: "Playlists",
      icon: CupertinoIcons.music_note_list,
      page: const PlaylistsView(),
    ),
    BottomNavButton(
      title: "Favoritas",
      icon: CupertinoIcons.heart,
      activeIcon: CupertinoIcons.heart_fill,
      page: const FavoritesView(),
      activeColor: Colors.pinkAccent,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioVM = Provider.of<AudioViewModel>(context, listen: true);
    tabController = TabController(
      length: audioVM.songsCopy.isEmpty ? 1 : navButtons.length,
      vsync: this,
      initialIndex: 0,
    );
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          AppVariables.appName,
          style: TextStyle(fontWeight: .bold),
        ),
        actions: [
          if (audioVM.isLoading)
            CupertinoActivityIndicator(color: Theme.of(context).primaryColor),
          const SizedBox(width: 20),
          IconButton(
            icon: const Icon(CupertinoIcons.settings),
            onPressed: () {
              Get.toNamed(AppRoutes.settings);
            },
          ),
          const SizedBox(width: 10),
        ],
        bottom: audioVM.isLoading || audioVM.songsCopy.isEmpty
            ? null
            : TabBar(
                controller: tabController,
                indicatorColor: Theme.of(context).primaryColor,
                labelColor: Theme.of(context).primaryColor,
                indicatorSize: TabBarIndicatorSize.label,
                labelPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                indicatorPadding: EdgeInsets.zero,
                indicatorWeight: 1,
                indicatorAnimation: .elastic,
                unselectedLabelColor: Theme.of(
                  context,
                ).textTheme.bodySmall!.color,
                dividerHeight: 0,
                tabAlignment: TabAlignment.fill,
                tabs: [
                  if (audioVM.songsCopy.isEmpty) ...[
                    Tab(text: '', height: 35, iconMargin: EdgeInsets.zero),
                  ] else ...[
                    ...navButtons.map(
                      (btn) => Tab(
                        icon: Icon(btn.icon, size: 18),
                        height: 35,
                        iconMargin: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ],
              ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          if (audioVM.songsCopy.isEmpty) ...[
            navButtons[0].page,
          ] else ...[
            ...navButtons.map((btn) => btn.page),
          ],
        ],
      ),
      bottomNavigationBar: const AudioPlayerComponent(
        margin: .only(bottom: 10, left: 10, right: 10),
      ),
    );
  }
}
