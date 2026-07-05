import 'package:beatsvibe/components/player/artwork_player.dart';
import 'package:beatsvibe/components/player/info_player.dart';
import 'package:beatsvibe/components/player/progress_player.dart';
import 'package:beatsvibe/components/player/queue_player.dart';
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
    final playerVM = Provider.of<PlayerViewModel>(context, listen: false);
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
            const InfoPlayer(),
            const ProgressPlayer(),
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
  }

  void openQueue(BuildContext context) {
    Get.bottomSheet(
      const QueuePlayer()
    );
  }
}
