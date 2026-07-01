import 'dart:convert';
import 'dart:io';

import 'package:beatsvibe/models/mediaitem_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioItem extends StatefulWidget {
  final MediaItemData song;
  final bool isSelected;
  final int index;
  final List<MediaItemData>? playlist;

  const AudioItem({
    super.key,
    required this.song,
    required this.index,
    this.isSelected = false,
    this.playlist,
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
    return Padding(
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
                        CupertinoIcons.music_note,
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
                    if (widget.song.format != null &&
                        widget.song.bitrate != null) ...[
                      _buildFormatTag(
                        widget.song.format!,
                        widget.song.bitrate!,
                      ),
                    ],
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatTag(AudioFormat format, int bitrate) {
    int bt = (bitrate / 1000).toInt();
    if (format == AudioFormat.mp3) {
      if (bt < 192) {
        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColor.withValues(alpha: .5),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const .all(4),
            child: Text(
              'SD',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        );
      }
      if (bt >= 192 && bt < 256) {
        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColor.withValues(alpha: .5),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const .all(4),
            child: Text(
              'HD',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        );
      }
      if (bt >= 256) {
        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.amberAccent),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const .all(4),
            child: Text(
              'Hi-Res',
              style: TextStyle(fontSize: 10, color: Colors.amberAccent),
            ),
          ),
        );
      }
    }
    if (format == AudioFormat.flac) {
      return DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.greenAccent),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const .all(4),
          child: Text(
            'Lossless',
            style: TextStyle(fontSize: 10, color: Colors.greenAccent),
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }
}
