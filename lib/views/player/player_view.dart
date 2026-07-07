import 'package:beatsvibe/components/player/artwork_player.dart';
import 'package:beatsvibe/components/player/audiocontrols_players.dart';
import 'package:beatsvibe/components/player/audioinfo_player.dart';
import 'package:beatsvibe/components/player/progress_player.dart';
import 'package:beatsvibe/components/player/queue_player.dart';
import 'package:beatsvibe/components/player/schema_color_component.dart';
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
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: const SchemaColorComponent()),
          Positioned(
            child: SafeArea(
              child: Column(
                children: [
                  Consumer<PlayerViewModel>(
                    builder: (context, playerVM, child) {
                      return Padding(
                        padding: const .symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 45,
                              height: 45,
                              child: IconButton(
                                onPressed: () => Get.back(),
                                icon: Icon(
                                  CupertinoIcons.chevron_back,
                                  color: playerVM.currentItem?.artUri != null
                                      ? Colors.white
                                      : Theme.brightnessOf(context) == .dark
                                          ? Colors.white
                                          : Colors.grey,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      playerVM.currentItem?.artUri != null
                                          ? Colors.white.withValues(alpha: .15)
                                          : Theme.brightnessOf(context) ==
                                                .dark
                                          ? Colors.white.withValues(alpha: .2)
                                          : Colors.grey.withValues(alpha: .1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  Center(child: ArtworkPlayer()),
                  const SizedBox(height: 20),
                  const AudioInfoPlayer(),
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
                            child: Consumer<PlayerViewModel>(
                              builder: (context, playerVM, child) =>
                                  GestureDetector(
                                    onTap: () {
                                      playerVM.setRepeatMode();
                                    },
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color:
                                            playerVM.currentItem?.artUri != null
                                            ? Colors.white.withValues(
                                                alpha: .15,
                                              )
                                            : Theme.brightnessOf(context) ==
                                                  .dark
                                            ? Colors.white.withValues(alpha: .2)
                                            : Colors.grey.withValues(alpha: .1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          playerVM.repeatMode == .none
                                              ? CupertinoIcons.repeat
                                              : playerVM.repeatMode == .one
                                              ? CupertinoIcons.shuffle
                                              : CupertinoIcons.repeat_1,
                                          size: 25,
                                          color:
                                              playerVM.currentItem?.artUri !=
                                                  null
                                              ? Colors.white
                                              : Theme.brightnessOf(context) ==
                                                    .dark
                                              ? Colors.white
                                              : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                          Spacer(),
                          const AudioControlsPlayer(),
                          Spacer(),
                          SizedBox(
                            width: 45,
                            height: 45,
                            child: Consumer<PlayerViewModel>(
                              builder: (context, playerVM, child) =>
                                  GestureDetector(
                                    onTap: () => openQueue(context),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color:
                                            playerVM.currentItem?.artUri != null
                                            ? Colors.white.withValues(
                                                alpha: .15,
                                              )
                                            : Theme.brightnessOf(context) ==
                                                  .dark
                                            ? Colors.white.withValues(alpha: .2)
                                            : Colors.grey.withValues(alpha: .1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          CupertinoIcons.music_albums,
                                          size: 25,
                                          color:
                                              playerVM.currentItem?.artUri !=
                                                  null
                                              ? Colors.white
                                              : Theme.brightnessOf(context) ==
                                                    .dark
                                              ? Colors.white
                                              : Colors.grey,
                                        ),
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
          ),
        ],
      ),
    );
  }

  void openQueue(BuildContext context) {
    Get.bottomSheet(const QueuePlayer());
  }
}
