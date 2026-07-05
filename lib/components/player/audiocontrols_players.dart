import 'package:beatsvibe/vm/player_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AudioControlsPlayer extends StatefulWidget {
  const AudioControlsPlayer({super.key});

  @override
  State<AudioControlsPlayer> createState() => _AudioControlsPlayerState();
}

class _AudioControlsPlayerState extends State<AudioControlsPlayer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerViewModel>(
      builder: (context, playerVM, child) {
        return Row(
          children: [
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
          ],
        );
      },
    );
  }
}
