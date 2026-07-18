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
                    color: Colors.white.withValues(alpha: .15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      CupertinoIcons.backward_end,
                      size: 30,
                      color: Colors.white,
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
                    playerVM.play();
                  }
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      playerVM.isPlaying
                          ? CupertinoIcons.pause
                          : CupertinoIcons.play,
                      size: 50,
                      color: Colors.white,
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
                    color: Colors.white.withValues(alpha: .15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      CupertinoIcons.forward_end,
                      size: 30,
                      color: Colors.white,
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
