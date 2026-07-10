import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:beatsvibe/variables.dart';
import 'package:beatsvibe/vm/favorites_vm.dart';
import 'package:beatsvibe/vm/player_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_color_scheme/image_color_scheme.dart';
import 'package:provider/provider.dart';

class ArtworkPlayer extends StatefulWidget {
  const ArtworkPlayer({super.key});

  @override
  State<ArtworkPlayer> createState() => _ArtworkPlayerState();
}

class _ArtworkPlayerState extends State<ArtworkPlayer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesVM = Provider.of<FavoritesViewModel>(context, listen: false);
    return Consumer<PlayerViewModel>(
      builder: (context, playerVM, child) {
        return SizedBox(
          width: 360,
          height: 320,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    if (playerVM.currentItem?.artUri != null) ...[
                      Positioned.fill(
                        child: playerVM.currentItem!.artUri!.scheme == 'file'
                            ? Image.file(
                                File.fromUri(playerVM.currentItem!.artUri!),
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
                              ? Colors.white.withValues(alpha: .1)
                              : Colors.grey.shade200,
                        ),
                        child: Center(
                          child: SvgPicture.asset(AppVariables.appLogo, width: 180, height: 180),
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
                              if (playerVM.currentItem != null ||
                                  playerVM.lastPlayed != null) {
                                favoritesVM.toggleFavorite(
                                  song:
                                      playerVM.currentItem ??
                                      playerVM.lastPlayed!,
                                );
                              }
                            },
                            child: playerVM.currentItem?.artUri != null
                                ? ImageColorSchemeBuilder(
                                    provider: Image.file(
                                      File.fromUri(
                                        playerVM.currentItem!.artUri!,
                                      ),
                                    ).image,
                                    builder: (context, colorScheme, child) =>
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            360,
                                          ),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaX: 5,
                                              sigmaY: 5,
                                            ),
                                            child: Container(
                                              color:
                                                  playerVM
                                                          .currentItem
                                                          ?.artUri !=
                                                      null
                                                  ? colorScheme.primary
                                                        .withValues(alpha: .3)
                                                  : Theme.brightnessOf(
                                                          context,
                                                        ) ==
                                                        .dark
                                                  ? Colors.white.withValues(
                                                      alpha: .1,
                                                    )
                                                  : Colors.black12.withValues(
                                                      alpha: .05,
                                                    ),
                                              child: Center(
                                                child: Icon(
                                                  favoritesVM.favorites.any(
                                                        (element) =>
                                                            element.id ==
                                                            (playerVM
                                                                    .currentItem
                                                                    ?.id ??
                                                                playerVM
                                                                    .lastPlayed
                                                                    ?.id),
                                                      )
                                                      ? CupertinoIcons
                                                            .heart_fill
                                                      : CupertinoIcons.heart,
                                                  color:
                                                      favoritesVM.favorites.any(
                                                        (element) =>
                                                            element.id ==
                                                            (playerVM
                                                                    .currentItem
                                                                    ?.id ??
                                                                playerVM
                                                                    .lastPlayed
                                                                    ?.id),
                                                      )
                                                      ? Colors.pinkAccent
                                                      : playerVM
                                                                .currentItem
                                                                ?.artUri !=
                                                            null
                                                      ? Colors.white
                                                      : Theme.brightnessOf(
                                                              context,
                                                            ) ==
                                                            .dark
                                                      ? Colors.white
                                                      : Colors.redAccent,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(360),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 5,
                                        sigmaY: 5,
                                      ),
                                      child: Container(
                                        color:
                                            Theme.brightnessOf(context) == .dark
                                            ? Colors.white.withValues(alpha: .1)
                                            : Colors.black12.withValues(
                                                alpha: .05,
                                              ),
                                        child: Center(
                                          child: Icon(
                                            favoritesVM.favorites.any(
                                                  (element) =>
                                                      element.id ==
                                                      (playerVM
                                                              .currentItem
                                                              ?.id ??
                                                          playerVM
                                                              .lastPlayed
                                                              ?.id),
                                                )
                                                ? CupertinoIcons.heart_fill
                                                : CupertinoIcons.heart,
                                            color:
                                                favoritesVM.favorites.any(
                                                  (element) =>
                                                      element.id ==
                                                      (playerVM
                                                              .currentItem
                                                              ?.id ??
                                                          playerVM
                                                              .lastPlayed
                                                              ?.id),
                                                )
                                                ? Colors.pinkAccent
                                                : playerVM
                                                          .currentItem
                                                          ?.artUri !=
                                                      null
                                                ? Colors.white
                                                : Theme.brightnessOf(context) ==
                                                      .dark
                                                ? Colors.white
                                                : Colors.redAccent,
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
        );
      },
    );
  }
}
