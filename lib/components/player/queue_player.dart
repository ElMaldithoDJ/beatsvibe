import 'package:beatsvibe/components/audio_item.dart';
import 'package:beatsvibe/vm/player_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QueuePlayer extends StatefulWidget {
  const QueuePlayer({super.key});

  @override
  State<QueuePlayer> createState() => _QueuePlayerState();
}

class _QueuePlayerState extends State<QueuePlayer> {
  @override
  Widget build(BuildContext context) {
    final playerVM = Provider.of<PlayerViewModel>(context, listen: false);
    return Container(
      width: .maxFinite,
      constraints: BoxConstraints(maxHeight: 520),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.brightnessOf(context) == .dark
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.white,
      ),
      child: Column(
        mainAxisSize: .min,
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
              itemCount: playerVM.queue?.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              itemBuilder: (context, index) {
                final song = playerVM.queue![index];
                return GestureDetector(
                  onTap: () {
                    if (song.id != playerVM.currentItem?.id) {
                      playerVM.play(song: song, playlist: playerVM.queue);
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
    );
  }
}
