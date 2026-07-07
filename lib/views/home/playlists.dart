import 'package:beatsvibe/components/playlist_cupertino.dart';
import 'package:beatsvibe/routes.dart';
import 'package:beatsvibe/theme.dart';
import 'package:beatsvibe/vm/playlist_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PlaylistsView extends StatefulWidget {
  const new({super.key});

  @override
  State<PlaylistsView> createState() => _PlaylistsViewState();
}

class _PlaylistsViewState extends State<PlaylistsView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistViewModel>(
      builder: (context, playlistVM, _) {
        return Stack(
          children: [
            if (playlistVM.playlists.isEmpty) ...[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.music_albums,
                      size: 50,
                      color: Theme.brightnessOf(context) == .dark
                          ? Colors.white
                          : Colors.black,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "No hay playlists",
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.brightnessOf(context) == .dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Positioned.fill(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemCount: playlistVM.playlists.length,
                  itemBuilder: (context, index) {
                    final playlist = playlistVM.playlists[index];
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.playlistView,
                          arguments: playlist,
                        );
                      },
                      child: PlaylistContextMenu(
                        actions: [
                          PlaylistMenuItem(
                            title: "Editar",
                            icon: CupertinoIcons.pencil,
                            onTap: () {},
                          ),
                          PlaylistMenuItem(
                            title: "Eliminar",
                            icon: CupertinoIcons.trash,
                            isDestructive: true,
                            onTap: () async {
                              await playlistVM.removePlaylist(playlist.id!);
                            },
                          ),
                        ],
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.brightnessOf(context) == .dark
                                ? AppTheme.playerDarkBgColor
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.music_albums,
                                size: 50,
                                color: Theme.brightnessOf(context) == .dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "${playlist.songs!.length} canciones",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.brightnessOf(context) == .dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "${playlist.title}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.brightnessOf(context) == .dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            Positioned(
              bottom: (playlistVM.audioHandler.mediaItem.value != null) ? 80 : 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.createPlaylist);
                },
                backgroundColor: AppTheme.primaryColor,
                child: Icon(CupertinoIcons.add, color: Colors.white,),
              ),
            ),
          ],
        );
      },
    );
  }
}
