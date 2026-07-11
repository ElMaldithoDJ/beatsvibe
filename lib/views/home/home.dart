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

  int currentIndex = 0;
  late PageController pageController = PageController(initialPage: currentIndex);

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
  Widget build(BuildContext context) {
    final audioVM = Provider.of<AudioViewModel>(context, listen: true);
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
            icon: const Icon(CupertinoIcons.gear_alt),
            onPressed: () {
              Get.toNamed(AppRoutes.settings);
            },
          ),
          const SizedBox(width: 10),
        ],
        bottom: audioVM.isLoading || audioVM.songsCopy.isEmpty
            ? null
            : PreferredSize(
                preferredSize: Size(.maxFinite, 25),
                child: Row(
                  children: [
                    ...navButtons.map(
                      (btn) => Expanded(
                        child: BottomNavButton(
                          icon: btn.icon,
                          activeIcon: btn.activeIcon,
                          page: btn.page,
                          activeColor: btn.activeColor,
                          isActive: currentIndex == navButtons.indexOf(btn),
                          onTap: () {
                            setState(() {
                              currentIndex = navButtons.indexOf(btn);
                              pageController.animateToPage(
                                currentIndex,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.ease,
                              );
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: [
          if (audioVM.songsCopy.isEmpty) ...[
            navButtons[0].page,
          ] else ...[
            ...navButtons.map((btn) => btn.page),
          ],
        ],
      ),
      bottomNavigationBar: const AudioPlayerComponent(),
    );
  }
}
