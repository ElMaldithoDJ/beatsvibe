import 'package:audio_service/audio_service.dart';
import 'package:beatsvibe/components/audio_item.dart';
import 'package:beatsvibe/models/mediaitem_data.dart';
import 'package:beatsvibe/vm/player_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QueuePlayer extends StatefulWidget {
  const QueuePlayer({super.key});

  @override
  State<QueuePlayer> createState() => _QueuePlayerState();
}

class _QueuePlayerState extends State<QueuePlayer> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _itemKeys = {};
  List<MediaItemData> queue = [];
  MediaItem? currentItem;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentPlaying();
      final playerVM = Provider.of<PlayerViewModel>(context, listen: false);
      setState(() {
        queue = playerVM.queue;
        currentItem = playerVM.currentItem;
      });
    });
  }

  void _scrollToCurrentPlaying() {
    if (!mounted) return;
    final playerVM = Provider.of<PlayerViewModel>(context, listen: false);
    if (playerVM.currentItem != null && playerVM.queue.isNotEmpty) {
      final key = _itemKeys[playerVM.currentItem!.id];
      if (key != null && key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        final index = playerVM.queue.indexWhere((s) => s.id == playerVM.currentItem!.id);
        if (index != -1 && _scrollController.hasClients) {
          // Altura aproximada de un AudioItem (40 imagen + 12 padding) = 52.0
          final offset = index * 52.0;
          _scrollController.jumpTo(
            offset,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerVM = Provider.of<PlayerViewModel>(context);
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
              controller: _scrollController,
              itemCount: queue.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              itemBuilder: (context, index) {
                final song = queue[index];
                final key = _itemKeys.putIfAbsent(song.id, () => GlobalKey());
                return GestureDetector(
                  onTap: () {
                    if (song.id != currentItem?.id) {
                      playerVM.play(song: song, playlist: queue);
                    }
                  },
                  child: AudioItem(
                    key: key,
                    song: song,
                    isPlaying: playerVM.currentIndex == index,
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
