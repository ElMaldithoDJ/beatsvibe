import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:beatsvibe/routes.dart';
import 'package:beatsvibe/theme.dart';
import 'package:beatsvibe/vm/favorites_vm.dart';
import 'package:beatsvibe/vm/player_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_color_scheme/image_color_scheme.dart';
import 'package:provider/provider.dart';

class AudioPlayerComponent extends StatefulWidget {
  final EdgeInsets? padding;
  const AudioPlayerComponent({super.key, this.padding});

  @override
  State<AudioPlayerComponent> createState() => _AudioPlayerComponentState();
}

class _AudioPlayerComponentState extends State<AudioPlayerComponent> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PlayerViewModel, FavoritesViewModel>(
      builder: (context, playerVM, favoritesVM, child) {
        if (playerVM.currentItem == null) return const SizedBox.shrink();
        return AnimatedCrossFade(
          firstChild: playerVM.currentItem!.artUri != null
              ? ImageColorSchemeBuilder(
                  provider: Image.file(
                    File.fromUri(playerVM.currentItem!.artUri!),
                  ).image,
                  builder: (context, colorScheme, child) => Container(
                    padding:
                        widget.padding ??
                        const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary,
                          colorScheme.primaryFixed,
                        ],
                        begin: .topLeft,
                        end: .bottomRight,
                        stops: [.2, .7],
                        transform: const GradientRotation(math.pi / 6),
                      ),
                      borderRadius: BorderRadius.circular(360),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .1),
                          blurRadius: 10,
                          spreadRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    width: .maxFinite,
                    height: 55,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: GestureDetector(
                            onTap: () async {
                              await Get.toNamed(AppRoutes.player);
                            },
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: CircularProgressIndicator(
                                    value: playerVM.progress,
                                    strokeWidth: 2,
                                    color: playerVM.currentItem?.artUri != null
                                        ? Colors.white
                                        : Theme.brightnessOf(context) == .dark
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                    strokeCap: .round,
                                    backgroundColor:
                                        playerVM.currentItem?.artUri != null
                                        ? Colors.white10
                                        : Theme.brightnessOf(context) == .dark
                                        ? Colors.white10
                                        : Colors.black12,
                                  ),
                                ),
                                if (playerVM.currentItem?.artUri != null) ...[
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(360),
                                      child:
                                          playerVM
                                                  .currentItem!
                                                  .artUri!
                                                  .scheme ==
                                              'file'
                                          ? Image.file(
                                              File.fromUri(
                                                playerVM.currentItem!.artUri!,
                                              ),
                                              gaplessPlayback: true,
                                              width: 35,
                                              height: 35,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return DecoratedBox(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              360,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: Icon(
                                                          CupertinoIcons
                                                              .music_note,
                                                          color: Theme.of(
                                                            context,
                                                          ).primaryColor,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                            )
                                          : Image.memory(
                                              base64Decode(
                                                playerVM
                                                    .currentItem!
                                                    .artUri!
                                                    .path,
                                              ),
                                              gaplessPlayback: true,
                                              width: 35,
                                              height: 35,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return DecoratedBox(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              360,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: Icon(
                                                          CupertinoIcons
                                                              .music_note,
                                                          color: Theme.of(
                                                            context,
                                                          ).primaryColor,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                            ),
                                    ),
                                  ),
                                ] else ...[
                                  Align(
                                    alignment: .center,
                                    child: SizedBox(
                                      width: 35,
                                      height: 35,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            360,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            CupertinoIcons.music_note,
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await Get.toNamed(AppRoutes.player);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  playerVM.currentItem?.title ?? "some thing",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: .w700,
                                    color: playerVM.currentItem?.artUri != null
                                        ? Colors.white
                                        : null,
                                  ),
                                ),
                                Text(
                                  playerVM.currentItem?.artist ?? "some one",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: .w400,
                                    color: playerVM.currentItem?.artUri != null
                                        ? Colors.white
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            playerVM.isPlaying
                                ? CupertinoIcons.pause
                                : CupertinoIcons.play,
                            color: playerVM.currentItem?.artUri != null
                                ? Colors.white
                                : Theme.brightnessOf(context) == .dark
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            if (playerVM.isPlaying) {
                              playerVM.pause();
                            } else {
                              playerVM.play();
                            }
                          },
                        ),
                        const SizedBox(width: 5),
                        IconButton(
                          icon: Icon(
                            favoritesVM.favorites.any(
                                  (element) =>
                                      element.id == playerVM.currentItem?.id,
                                )
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                            color: playerVM.currentItem?.artUri != null
                                ? Colors.white
                                : Theme.brightnessOf(context) == .dark
                                ? Colors.white
                                : favoritesVM.favorites.any(
                                    (element) =>
                                        element.id == playerVM.currentItem?.id,
                                  )
                                ? Colors.pinkAccent
                                : Colors.black26,
                          ),
                          onPressed: () async {
                            if (playerVM.currentItem != null ||
                                playerVM.lastPlayed != null) {
                              await favoritesVM.toggleFavorite(
                                song:
                                    playerVM.currentItem ??
                                    playerVM.lastPlayed!,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  padding:
                      widget.padding ??
                      const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Theme.brightnessOf(context) == .dark
                        ? AppTheme.playerDarkBgColor
                        : AppTheme.playerLightBgColor,
                    borderRadius: BorderRadius.circular(360),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .1),
                        blurRadius: 10,
                        spreadRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  width: .maxFinite,
                  height: 55,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: GestureDetector(
                          onTap: () async {
                            await Get.toNamed(AppRoutes.player);
                          },
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: CircularProgressIndicator(
                                  value: playerVM.progress,
                                  strokeWidth: 2,
                                  color: Theme.brightnessOf(context) == .dark
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                  strokeCap: .round,
                                  backgroundColor:
                                      Theme.brightnessOf(context) == .dark
                                      ? Colors.white10
                                      : Colors.black12,
                                ),
                              ),
                              if (playerVM.currentItem?.artUri != null) ...[
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(360),
                                    child:
                                        playerVM.currentItem!.artUri!.scheme ==
                                            'file'
                                        ? Image.file(
                                            File.fromUri(
                                              playerVM.currentItem!.artUri!,
                                            ),
                                            gaplessPlayback: true,
                                            width: 35,
                                            height: 35,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            360,
                                                          ),
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        CupertinoIcons
                                                            .music_note,
                                                        color: Theme.of(
                                                          context,
                                                        ).primaryColor,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  );
                                                },
                                          )
                                        : Image.memory(
                                            base64Decode(
                                              playerVM
                                                  .currentItem!
                                                  .artUri!
                                                  .path,
                                            ),
                                            gaplessPlayback: true,
                                            width: 35,
                                            height: 35,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            360,
                                                          ),
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        CupertinoIcons
                                                            .music_note,
                                                        color: Theme.of(
                                                          context,
                                                        ).primaryColor,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  );
                                                },
                                          ),
                                  ),
                                ),
                              ] else ...[
                                Align(
                                  alignment: .center,
                                  child: SizedBox(
                                    width: 35,
                                    height: 35,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          360,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          CupertinoIcons.music_note,
                                          color: Theme.of(context).primaryColor,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await Get.toNamed(AppRoutes.player);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                playerVM.currentItem?.title ?? "some thing",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: .w700,
                                ),
                              ),
                              Text(
                                playerVM.currentItem?.artist ?? "some one",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: .w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          playerVM.isPlaying
                              ? CupertinoIcons.pause
                              : CupertinoIcons.play,
                          color: Theme.brightnessOf(context) == .dark
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          if (playerVM.isPlaying) {
                            playerVM.pause();
                          } else {
                            playerVM.play();
                          }
                        },
                      ),
                      const SizedBox(width: 5),
                      IconButton(
                        icon: Icon(
                          favoritesVM.favorites.any(
                                (element) =>
                                    element.id == playerVM.currentItem?.id,
                              )
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: Theme.brightnessOf(context) == .dark
                              ? Colors.white
                              : favoritesVM.favorites.any(
                                  (element) =>
                                      element.id == playerVM.currentItem?.id,
                                )
                              ? Colors.pinkAccent
                              : Colors.black26,
                        ),
                        onPressed: () async {
                          if (playerVM.currentItem != null ||
                              playerVM.lastPlayed != null) {
                            await favoritesVM.toggleFavorite(
                              song:
                                  playerVM.currentItem ?? playerVM.lastPlayed!,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
          secondChild: Container(
            padding:
                widget.padding ?? const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Theme.brightnessOf(context) == .dark
                  ? AppTheme.playerDarkBgColor
                  : AppTheme.playerLightBgColor,
              borderRadius: BorderRadius.circular(360),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .1),
                  blurRadius: 10,
                  spreadRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            width: .maxFinite,
            height: 55,
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: GestureDetector(
                    onTap: () async {
                      await Get.toNamed(AppRoutes.player);
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CircularProgressIndicator(
                            value: playerVM.progress,
                            strokeWidth: 2,
                            color: Theme.brightnessOf(context) == .dark
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            strokeCap: .round,
                            backgroundColor:
                                Theme.brightnessOf(context) == .dark
                                ? Colors.white10
                                : Colors.black12,
                          ),
                        ),
                        if (playerVM.currentItem?.artUri != null) ...[
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(360),
                              child:
                                  playerVM.currentItem!.artUri!.scheme == 'file'
                                  ? Image.file(
                                      File.fromUri(
                                        playerVM.currentItem!.artUri!,
                                      ),
                                      gaplessPlayback: true,
                                      width: 35,
                                      height: 35,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return DecoratedBox(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(360),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  CupertinoIcons.music_note,
                                                  color: Theme.of(
                                                    context,
                                                  ).primaryColor,
                                                  size: 20,
                                                ),
                                              ),
                                            );
                                          },
                                    )
                                  : Image.memory(
                                      base64Decode(
                                        playerVM.currentItem!.artUri!.path,
                                      ),
                                      gaplessPlayback: true,
                                      width: 35,
                                      height: 35,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return DecoratedBox(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(360),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  CupertinoIcons.music_note,
                                                  color: Theme.of(
                                                    context,
                                                  ).primaryColor,
                                                  size: 20,
                                                ),
                                              ),
                                            );
                                          },
                                    ),
                            ),
                          ),
                        ] else ...[
                          Align(
                            alignment: .center,
                            child: SizedBox(
                              width: 35,
                              height: 35,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(360),
                                ),
                                child: Center(
                                  child: Icon(
                                    CupertinoIcons.music_note,
                                    color: Theme.of(context).primaryColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      await Get.toNamed(AppRoutes.player);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playerVM.currentItem?.title ?? "some thing",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, fontWeight: .w700),
                        ),
                        Text(
                          playerVM.currentItem?.artist ?? "some one",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 10, fontWeight: .w400),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    playerVM.isPlaying
                        ? CupertinoIcons.pause
                        : CupertinoIcons.play,
                    color: Theme.brightnessOf(context) == .dark
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    if (playerVM.isPlaying) {
                      playerVM.pause();
                    } else {
                      playerVM.play();
                    }
                  },
                ),
                const SizedBox(width: 5),
                IconButton(
                  icon: Icon(
                    favoritesVM.favorites.any(
                          (element) => element.id == playerVM.currentItem?.id,
                        )
                        ? CupertinoIcons.heart_fill
                        : CupertinoIcons.heart,
                    color: Theme.brightnessOf(context) == .dark
                        ? Colors.white
                        : favoritesVM.favorites.any(
                            (element) => element.id == playerVM.currentItem?.id,
                          )
                        ? Colors.pinkAccent
                        : Colors.black26,
                  ),
                  onPressed: () async {
                    if (playerVM.currentItem != null ||
                        playerVM.lastPlayed != null) {
                      await favoritesVM.toggleFavorite(
                        song: playerVM.currentItem ?? playerVM.lastPlayed!,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          crossFadeState: playerVM.currentItem == null
              ? .showSecond
              : .showFirst,
          duration: const Duration(seconds: 1),
        );
      },
    );
  }
}
