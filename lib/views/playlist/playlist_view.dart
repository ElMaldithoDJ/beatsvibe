import 'package:beatsvibe/components/audio_cupertino.dart';
import 'package:beatsvibe/components/audio_item.dart';
import 'package:beatsvibe/models/playlist_data.dart';
import 'package:beatsvibe/vm/player_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    final playerVM = Provider.of<PlayerViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(CupertinoIcons.back),
        ),
        title: Text(widget.playlist.title),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.pencil)),
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.ellipsis)),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              width: .maxFinite,
              height: 200,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.brightnessOf(context) == .dark
                      ? Colors.white.withValues(alpha: .15)
                      : Colors.grey.shade100,
                ),
              ),
            ),
            SizedBox(height: 15),
            for (int i = 0; i < widget.playlist.songs!.length; i++) ...[
              AudioCupertinoContextMenu(
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
                child: GestureDetector(
                  onTap: () {
                    playerVM.play(
                      widget.playlist.songs![i],
                      playlist: widget.playlist.songs,
                    );
                  },
                  child: AudioItem(song: widget.playlist.songs![i], index: i),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
