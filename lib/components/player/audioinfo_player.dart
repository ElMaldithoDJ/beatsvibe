import 'package:beatsvibe/vm/player_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AudioInfoPlayer extends StatefulWidget {
  const AudioInfoPlayer({super.key});

  @override
  State<AudioInfoPlayer> createState() => _AudioInfoPlayerState();
}

class _AudioInfoPlayerState extends State<AudioInfoPlayer> {
   @override
  Widget build(BuildContext context) {
    return Consumer<PlayerViewModel>(
      builder: (context, playerVM, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Text(
              playerVM.currentItem != null ? playerVM.currentItem!.title : "",
              style: TextStyle(
                      color: playerVM.currentItem?.artUri != null
                          ? Colors.white
                          : Theme.brightnessOf(context) == .dark
                          ? Colors.white
                          : Colors.grey,
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
                      color: playerVM.currentItem?.artUri != null
                          ? Colors.white
                          : Theme.brightnessOf(context) == .dark
                          ? Colors.white
                          : Colors.grey,
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
    );
  }
}
