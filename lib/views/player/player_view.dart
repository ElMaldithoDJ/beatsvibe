import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:beatsvibe/components/audio_item.dart';
import 'package:beatsvibe/vm/favorites_vm.dart';
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
    return Consumer2<PlayerViewModel, FavoritesViewModel>(
      builder: (context, playerVM, favoritesVM, child) {
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
                Center(
                  child: SizedBox(
                    width: 360,
                    height: 320,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            children: [
                              if (playerVM.currentItem?.artUri != null) ...[
                                Positioned.fill(
                                  child:
                                      playerVM.currentItem!.artUri!.scheme ==
                                          'file'
                                      ? Image.file(
                                          File.fromUri(
                                            playerVM.currentItem!.artUri!,
                                          ),
                                          width: double.maxFinite,
                                          height: double.maxFinite,
                                          fit: BoxFit.cover,
                                          gaplessPlayback: true,
                                        )
                                      : Image.memory(
                                          base64Decode(
                                            playerVM.currentItem!.artUri!.path,
                                          ),
                                          width: double.maxFinite,
                                          height: double.maxFinite,
                                          fit: BoxFit.cover,
                                          gaplessPlayback: true,
                                        ),
                                ),
                              ] else ...[
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Theme.brightnessOf(context) == .dark
                                        ? Colors.white.withValues(alpha: .2)
                                        : Colors.grey.withValues(alpha: .2),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      CupertinoIcons.music_note,
                                      color: Theme.of(context).primaryColor,
                                      size: 80,
                                    ),
                                  ),
                                ),
                              ],
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Align(
                                  alignment: .bottomRight,
                                  child: SizedBox(
                                    width: 55,
                                    height: 55,
                                    child: GestureDetector(
                                      onTap: () async {
                                        await playerVM.likeSong(null);
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          360,
                                        ),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 5,
                                            sigmaY: 5,
                                          ),
                                          child: Container(
                                            color: Colors.white.withValues(
                                              alpha: .15,
                                            ),
                                            child: Center(
                                              child: Icon(
                                                playerVM.isFavorite
                                                    ? CupertinoIcons.heart_fill
                                                    : CupertinoIcons.heart,
                                                color: playerVM.isFavorite
                                                    ? Colors.red
                                                    : Colors.white,
                                                size: 25,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Align(
                                  alignment: .topRight,
                                  child: SizedBox(
                                    width: 55,
                                    height: 55,
                                    child: GestureDetector(
                                      onTap: () async {
                                        await playerVM.likeSong(null);
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 5,
                                            sigmaY: 5,
                                          ),
                                          child: Container(
                                            color: Colors.white.withValues(
                                              alpha: .15,
                                            ),
                                            child: Center(
                                              child: Icon(
                                                CupertinoIcons.share,
                                                size: 25,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  playerVM.currentItem != null
                      ? playerVM.currentItem!.title
                      : "",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                if (playerVM.currentItem?.artist != null) ...[
                  Text(
                    playerVM.currentItem!.artist!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 3,
                    thumbColor: Theme.brightnessOf(context) == .dark
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8,
                    ),
                    trackShape: const RoundedRectSliderTrackShape(),

                    overlayColor: Colors.transparent,
                    activeTrackColor: Theme.brightnessOf(context) == .dark
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                  ),
                  child: Slider(
                    min: 0,
                    max: 100,
                    value: playerVM.progress * 100,
                    onChanged: (value) {
                      playerVM.seek(
                        Duration(
                          milliseconds:
                              (playerVM.duration.inMilliseconds * value / 100)
                                  .round(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const .symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Text(playerVM.currentPositionString),
                      Spacer(),
                      Text(playerVM.durationString),
                    ],
                  ),
                ),

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
                        Spacer(),
                        SizedBox(
                          width: 45,
                          height: 45,
                          child: GestureDetector(
                            onTap: () {
                              Get.bottomSheet(
                                Container(
                                  width: .maxFinite,
                                  constraints: BoxConstraints(
                                    maxHeight: Get.height * .50,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Theme.brightnessOf(context) == .dark
                                        ? Theme.of(
                                            context,
                                          ).scaffoldBackgroundColor
                                        : Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const .symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        child: Text(
                                          "Lista de reproducción",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: playerVM.queue.length,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                playerVM.play(index);
                                              },
                                              child: AudioItem(
                                                song: playerVM.queue[index],
                                                index: index,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
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
      },
    );
  }
}
