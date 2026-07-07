import 'package:beatsvibe/components/audio_cupertino.dart';
import 'package:beatsvibe/components/audio_item.dart';
import 'package:beatsvibe/models/playlist_data.dart';
import 'package:beatsvibe/vm/player_vm.dart';
import 'package:beatsvibe/vm/playlist_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file_manager/open_file_manager.dart';
import 'package:provider/provider.dart';

class PlaylistView extends StatefulWidget {
  final PlaylistModelData playlist = Get.arguments;
  PlaylistView({super.key});

  @override
  State<PlaylistView> createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  @override
  Widget build(BuildContext context) {
    final playlistVM = Provider.of<PlaylistViewModel>(context, listen: false);
    final playerVM = Provider.of<PlayerViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(CupertinoIcons.back),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.ellipsis)),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              width: .maxFinite,
              height: 250,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.brightnessOf(context) == .dark
                            ? Colors.white.withValues(alpha: .05)
                            : Colors.grey.shade100,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    child: Align(
                      alignment: .topLeft,
                      child: Padding(
                        padding: const .only(top: 10),
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              "${widget.playlist.title}",
                              style: TextStyle(fontSize: 20, fontWeight: .bold),
                            ),
                            Text(
                              "${widget.playlist.songs!.length} canciones",
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 15,
                    bottom: 10,
                    child: Align(
                      alignment: .bottomRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.brightnessOf(context) == .dark
                              ? Colors.white.withValues(alpha: .1)
                              : Colors.grey.shade200,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          playlistVM.playPlaylist(widget.playlist.songs!);
                        },
                        child: Row(
                          mainAxisSize: .min,
                          children: [
                            Icon(CupertinoIcons.play_arrow),
                            SizedBox(width: 5),
                            Text('Reproducir todo'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 15,
                    top: 10,
                    child: Align(
                      alignment: .topRight,
                      child: Tooltip(
                        message: 'Editar portada',
                        child: IconButton(
                          onPressed: () {
                            openFileManager(
                              androidConfig: AndroidConfig(
                                folderPath: "/storage/emulated/0/",
                                folderType: AndroidFolderType.recent,
                              ),
                            );
                          },
                          icon: Icon(CupertinoIcons.pencil),
                          style: IconButton.styleFrom(
                            backgroundColor:
                                Theme.brightnessOf(context) == .dark
                                ? Colors.white.withValues(alpha: .1)
                                : Colors.grey.shade200,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.playlist.songs!.length,
              itemBuilder: (context, index) {
                final song = widget.playlist.songs![index];
                return GestureDetector(
                  onTap: () {
                    if (song.id != playerVM.currentItem?.id) {
                      playerVM.play(song: song, playlist: widget.playlist.songs!);
                    }
                  },
                  child: AudioCupertinoContextMenu(
                    actions: [
                      AudioCupertinoMenuItem(
                        title: 'Agregar a favoritos',
                        icon: CupertinoIcons.heart,
                        onTap: () {},
                      ),
                      AudioCupertinoMenuItem(
                        title: 'Agregar a playlist',
                        icon: CupertinoIcons.add,
                        onTap: () {},
                      ),
                      AudioCupertinoMenuItem(
                        title: 'Agregar a cola',
                        icon: CupertinoIcons.list_bullet,
                        onTap: () {},
                      ),
                      AudioCupertinoMenuItem(
                        title: 'Información',
                        icon: CupertinoIcons.info,
                        onTap: () {},
                      ),
                    ],
                    child: AudioItem(song: song, index: index, showIsPlaying: true,),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
