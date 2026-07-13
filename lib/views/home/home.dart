import 'package:beatsvibe/components/audio_player_component.dart';
import 'package:beatsvibe/components/bottom_nav_button.dart';
import 'package:beatsvibe/routes.dart';
import 'package:beatsvibe/theme.dart';
import 'package:beatsvibe/variables.dart';
import 'package:beatsvibe/views/home/favorites.dart';
import 'package:beatsvibe/views/home/music.dart';
import 'package:beatsvibe/views/home/playlists.dart';
import 'package:beatsvibe/vm/audio_vm.dart';
import 'package:beatsvibe/vm/playlist_vm.dart';
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
  late PageController pageController = PageController(
    initialPage: currentIndex,
  );

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchNode = FocusNode();

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

  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void didUpdateWidget(covariant HomeRoute oldWidget) {
    if (currentIndex == 1) {
      _fabController.forward();
    } else {
      _fabController.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchNode.dispose();
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioVM = Provider.of<AudioViewModel>(context, listen: true);
    final playlistVM = Provider.of<PlaylistViewModel>(context, listen: false);
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            child: SizedBox(
              height: 45,
              child: TextField(
                controller: _searchController,
                focusNode: _searchNode,
                decoration: InputDecoration(
                  hintText: currentIndex == 0
                      ? 'Titulo o Artista'
                      : currentIndex > 1
                          ? 'Titulo o Artista'
                          : 'Titulo de la playlist',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  if (currentIndex < 1) {
                    audioVM.onSearch(value);
                  } else if (currentIndex < 2) {
                    playlistVM.searchPlaylist(value);
                  }
                },
                onTapOutside: (event) {
                  _searchNode.unfocus();
                },
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
                if (index == 1) {
                  _fabController.forward();
                } else {
                  _fabController.reverse();
                }
              },
              children: [
                if (audioVM.songsCopy.isEmpty) ...[
                  navButtons[0].page,
                ] else ...[
                  ...navButtons.map((btn) => btn.page),
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AudioPlayerComponent(),
      floatingActionButton: ScaleTransition(
        alignment: Alignment.center,
        scale: _fabController,
        child: FloatingActionButton(
          onPressed: () {
            Get.toNamed(AppRoutes.createPlaylist);
          },
          backgroundColor: AppTheme.primaryColor,
          child: Icon(CupertinoIcons.add, color: Colors.white),
        ),
      ),
    );
  }
}
