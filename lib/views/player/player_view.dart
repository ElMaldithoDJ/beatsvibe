import 'package:beatsvibe/components/audio_item.dart';
import 'package:beatsvibe/components/player/artwork_player.dart';
import 'package:beatsvibe/components/player/progress_player.dart';
import 'package:beatsvibe/vm/favorites_vm.dart';
import 'package:beatsvibe/vm/player_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PlayerView extends StatefulWidget {
  const PlayerView({super.key});

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PlayerViewModel, FavoritesViewModel>(
      builder: (context, playerVM, favoritesVM, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text("Reproduciendo"),
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(CupertinoIcons.back),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(child: ArtworkPlayer()),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        playerVM.currentItem != null
                            ? playerVM.currentItem!.title
                            : "",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (playerVM.currentItem?.artist != null &&
                          playerVM.currentItem!.artist!.isNotEmpty) ...[
                        Text(
                          playerVM.currentItem!.artist!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const ProgressPlayer(),
                const SizedBox(height: 20),

                const Spacer(),
                Padding(
                  padding: const .symmetric(horizontal: 15),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: .center,
                      children: [
                        SizedBox(
                          width: 45,
                          height: 45,
                          child: GestureDetector(
                            onTap: () {},
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Theme.brightnessOf(context) == .dark
                                    ? Colors.white.withValues(alpha: .2)
                                    : Colors.grey.withValues(alpha: .1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  CupertinoIcons.shuffle,
                                  size: 25,
                                  color: Theme.brightnessOf(context) == .dark
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          width: 55,
                          height: 55,
                          child: GestureDetector(
                            onTap: () {
                              playerVM.skipToPrevious();
                            },
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Theme.brightnessOf(context) == .dark
                                    ? Colors.white.withValues(alpha: .2)
                                    : Colors.grey.withValues(alpha: .1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  CupertinoIcons.back,
                                  size: 35,
                                  color: Theme.brightnessOf(context) == .dark
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        SizedBox(
                          width: 85,
                          height: 85,
                          child: GestureDetector(
                            onTap: () {
                              if (playerVM.isPlaying) {
                                playerVM.pause();
                              } else {
                                playerVM.play(null);
                              }
                            },
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Theme.brightnessOf(context) == .dark
                                    ? Colors.white.withValues(alpha: .2)
                                    : Colors.grey.withValues(alpha: .1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  playerVM.isPlaying
                                      ? CupertinoIcons.pause
                                      : CupertinoIcons.play,
                                  size: 50,
                                  color: Theme.brightnessOf(context) == .dark
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        SizedBox(
                          width: 55,
                          height: 55,
                          child: GestureDetector(
                            onTap: () {
                              playerVM.skipToNext();
                            },
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Theme.brightnessOf(context) == .dark
                                    ? Colors.white.withValues(alpha: .2)
                                    : Colors.grey.withValues(alpha: .1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  CupertinoIcons.forward,
                                  size: 35,
                                  color: Theme.brightnessOf(context) == .dark
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          width: 45,
                          height: 45,
                          child: GestureDetector(
                            onTap: () => openQueue(context),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Theme.brightnessOf(context) == .dark
                                    ? Colors.white.withValues(alpha: .2)
                                    : Colors.grey.withValues(alpha: .1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  CupertinoIcons.music_albums,
                                  size: 25,
                                  color: Theme.brightnessOf(context) == .dark
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }

  void openQueue(BuildContext context) {
    final playerVM = Provider.of<PlayerViewModel>(context, listen: false);
    Get.bottomSheet(
      Container(
        width: .maxFinite,
        constraints: BoxConstraints(maxHeight: Get.height * .50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.brightnessOf(context) == .dark
              ? Theme.of(context).scaffoldBackgroundColor
              : Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const .symmetric(horizontal: 10, vertical: 10),
              child: Text(
                "Lista de reproducción",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: playerVM.queue.length,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                itemBuilder: (context, index) {
                  final song = playerVM.queue[index];
                  return GestureDetector(
                    onTap: () {
                      if (song.id != playerVM.currentItem?.id) {
                        playerVM.play(song, playlist: playerVM.queue);
                      }
                    },
                    child: AudioItem(
                      song: song,
                      index: index,
                      showIsPlaying: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
