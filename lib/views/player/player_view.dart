import 'package:beatsvibe/components/player/artwork_player.dart';
import 'package:beatsvibe/components/player/audiocontrols_players.dart';
import 'package:beatsvibe/components/player/audioinfo_player.dart';
import 'package:beatsvibe/components/player/progress_player.dart';
import 'package:beatsvibe/components/player/queue_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                    const AudioControlsPlayer(),
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
