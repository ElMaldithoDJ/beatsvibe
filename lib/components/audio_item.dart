import 'dart:convert';
import 'dart:io';

import 'package:beatsvibe/models/mediaitem_data.dart';
import 'package:beatsvibe/vm/player_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AudioItem extends StatefulWidget {
  final MediaItemData song;
  final bool isSelected;
  final bool isFavorite;
  final bool showIsSelected;
  final bool showIsPlaying;
  final int index;
  final List<MediaItemData>? playlist;

  const AudioItem({
    super.key,
    required this.song,
    required this.index,
    this.isSelected = false,
    this.playlist,
    this.showIsSelected = true,
    this.isFavorite = false,
    this.showIsPlaying = false,
  });

  @override
  State<AudioItem> createState() => _AudioItemState();
}

class _AudioItemState extends State<AudioItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheCover();
  }

  void _precacheCover() {
    if (widget.song.artUri != null) {
      if (widget.song.artUri!.scheme == 'file') {
        precacheImage(
          Image.file(File.fromUri(widget.song.artUri!)).image,
          context,
        );
      } else {
        precacheImage(
          Image.memory(base64Decode(widget.song.artUri!.path)).image,
          context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<PlayerViewModel>(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              children: [
                if (widget.song.artUri != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(360),
                    child: widget.song.artUri!.scheme == 'file'
                        ? Image.file(
                            File.fromUri(widget.song.artUri!),
                            width: double.maxFinite,
                            height: double.maxFinite,
                            fit: BoxFit.cover,
                            gaplessPlayback: true,
                          )
                        : Image.memory(
                            base64Decode(widget.song.artUri!.path),
                            width: double.maxFinite,
                            height: double.maxFinite,
                            fit: BoxFit.cover,
                            gaplessPlayback: true,
                          ),
                  ),
                  if (player.currentItem?.id == widget.song.id &&
                      widget.showIsPlaying) ...[
                    Center(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.song.artUri != null
                              ? Colors.black54
                              : Theme.of(
                                  context,
                                ).primaryColor.withValues(alpha: .15),
                        ),
                        child: Center(
                          child: Icon(
                            player.isPlaying
                                ? CupertinoIcons.play_fill
                                : CupertinoIcons.pause,
                            color: widget.song.artUri != null
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ] else ...[
                  DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: .15),
                    ),
                    child: Center(
                      child: Icon(
                        player.currentItem?.id == widget.song.id
                            ? player.isPlaying
                                  ? CupertinoIcons.play_fill
                                  : CupertinoIcons.pause
                            : CupertinoIcons.music_note,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.song.title,
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  spacing: 8,
                  children: [
                    if (widget.song.artist != null &&
                        widget.song.artist!.isNotEmpty) ...[
                      Text(
                        widget.song.artist!,
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          if (widget.isSelected) ...[
            SizedBox(
              width: 25,
              height: 25,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor.withValues(alpha: .15),
                ),
                child: Center(
                  child: Icon(
                    CupertinoIcons.check_mark,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
          if (widget.isFavorite) ...[
            SizedBox(
              width: 30,
              height: 30,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor.withValues(alpha: .15),
                ),
                child: Center(
                  child: Icon(
                    CupertinoIcons.heart_fill,
                    color: Colors.pinkAccent,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
