import 'dart:convert';
import 'dart:io';

import 'package:beatsvibe/models/mediaitem_data.dart';
import 'package:beatsvibe/variables.dart';
import 'package:beatsvibe/vm/player_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class AudioItem extends StatefulWidget {
  final MediaItemData song;
  final bool isSelected;
  final bool isFavorite;
  final bool showIsSelected;
  final bool? showIsPlaying;
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

class _AudioItemState extends State<AudioItem> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn),
    );

    if (widget.isFavorite) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AudioItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isFavorite != oldWidget.isFavorite) {
      if (widget.isFavorite) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
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
                  if ((player.currentItem?.id == widget.song.id)) ...[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.song.artUri != null
                            ? Colors.black54
                            : Theme.of(context).primaryColor
                                  .withValues(alpha: .15),
                      ),
                      child: Center(
                        child: player.isPlaying && widget.showIsPlaying!
                            ? Icon(
                                CupertinoIcons.play_arrow_solid,
                                size: 20,
                                color: Colors.white,
                              )
                            : Icon(
                                CupertinoIcons.pause_solid,
                                size: 20,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ],
                ] else ...[
                  DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.brightnessOf(context) == .dark
                            ? Colors.white.withValues(alpha: .1)
                            : Colors.black.withValues(alpha: .1),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AppVariables.appLogo,
                        width: 35,
                        height: 35,
                      ),
                    ),
                  ),
                  if ((player.currentItem?.id == widget.song.id)) ...[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black45,
                      ),
                      child: Center(
                        child: player.isPlaying && widget.showIsPlaying!
                            ? Icon(
                                CupertinoIcons.play_arrow_solid,
                                size: 20,
                                color: Colors.white,
                              )
                            : Icon(
                                CupertinoIcons.pause_solid,
                                size: 20,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ],
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
                  style: TextStyle(
                    color: Theme.brightnessOf(context) == .dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
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
                        style: TextStyle(
                          color: Theme.brightnessOf(context) == .dark
                              ? Colors.grey
                              : Colors.black,
                          fontSize: 10,
                        ),
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
          SizedBox(
            width: 25,
            height: 25,
            child: ScaleTransition(
              alignment: .center,
              scale: _scaleAnimation,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.pinkAccent.withValues(alpha: .15),
                ),
                child: Center(
                  child: Icon(
                    CupertinoIcons.heart_fill,
                    color: Colors.pinkAccent,
                    size: 15,
                  ),
                ),
              ),
            ),
          ),
          if (widget.isSelected) ...[
            SizedBox(
              width: 20,
              height: 20,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor.withValues(alpha: .15),
                ),
                child: Center(
                  child: Icon(
                    CupertinoIcons.check_mark,
                    color: Theme.of(context).primaryColor,
                    size: 10,
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
