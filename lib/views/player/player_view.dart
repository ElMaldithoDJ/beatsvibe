import 'package:beatsvibe/components/player/artwork_player.dart';
import 'package:beatsvibe/components/player/audiocontrols_players.dart';
import 'package:beatsvibe/components/player/audioinfo_player.dart';
import 'package:beatsvibe/components/player/progress_player.dart';
import 'package:beatsvibe/components/player/queue_player.dart';
import 'package:beatsvibe/models/repeatmode_model.dart';
import 'package:beatsvibe/theme.dart';
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

class _PlayerViewState extends State<PlayerView>
    with SingleTickerProviderStateMixin {
  bool _canPop = false;

  Color defaultColor = AppTheme.playerDarkBgColor;

  @override
  void initState() {
    super.initState();
  }

  void _onBackPressed() async {
    if (_canPop) return;
    if (mounted) {
      setState(() {
        _canPop = true;
      });
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        _onBackPressed();
      },
      child: Consumer<PlayerViewModel>(
        builder: (context, playerVM, child) {
          return Scaffold(
            backgroundColor: playerVM.currentItem?.artUri == null
                ? defaultColor
                : playerVM.artColors?.darkDominantColor,
            appBar: AppBar(
              toolbarHeight: 0,
              elevation: 0,
              backgroundColor: playerVM.currentItem!.artUri == null
                  ? defaultColor
                  : Colors.transparent,
              flexibleSpace: AnimatedCrossFade(
                firstCurve: Curves.easeOutCubic,
                secondCurve: Curves.easeOutCubic,
                crossFadeState: playerVM.currentItem!.artUri == null
                    ? .showFirst
                    : .showSecond,
                duration: const Duration(milliseconds: 800),
                firstChild: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.playerDarkBgColor.withValues(alpha: .85),
                  ),
                ),
                secondChild: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent
                  ),
                ),
              ),
            ),
            body: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedCrossFade(
                    firstCurve: Curves.easeInOutBack,
                    secondCurve: Curves.easeInOutBack,
                    crossFadeState: playerVM.currentItem!.artUri == null
                        ? .showFirst
                        : .showSecond,
                    duration: const Duration(milliseconds: 800),
                    firstChild: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.playerDarkBgColor.withValues(
                          alpha: .85,
                        ),
                      ),
                    ),
                    secondChild: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomRight,
                          colors: [
                            playerVM.artColors?.darkDominantColor?.withValues(
                                  alpha: .85,
                                ) ??
                                AppTheme.playerDarkBgColor.withValues(
                                  alpha: .85,
                                ),
                            playerVM.artColors?.darkDominantColor?.withValues(
                                  alpha: .1,
                                ) ??
                                AppTheme.playerDarkBgColor.withValues(
                                  alpha: .85,
                                ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: const .symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 45,
                                height: 45,
                                child: IconButton(
                                  onPressed: _onBackPressed,
                                  icon: Icon(
                                    CupertinoIcons.chevron_back,
                                    color: Colors.white,
                                  ),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Center(child: ArtworkPlayer()),
                        const SizedBox(height: 20),
                        const AudioInfoPlayer(),
                        const ProgressPlayer(),
                        const SizedBox(height: 185),
                        Padding(
                          padding: const .symmetric(horizontal: 15),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: .center,
                              children: [
                                SizedBox(
                                  width: 45,
                                  height: 45,
                                  child: Consumer<PlayerViewModel>(
                                    builder: (context, playerVM, child) =>
                                        GestureDetector(
                                          onTap: () {
                                            playerVM.setRepeatMode();
                                          },
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              color:
                                                  playerVM
                                                          .currentItem
                                                          ?.artUri !=
                                                      null
                                                  ? Colors.white.withValues(
                                                      alpha: .15,
                                                    )
                                                  : Theme.brightnessOf(
                                                          context,
                                                        ) ==
                                                        .dark
                                                  ? Colors.white.withValues(
                                                      alpha: .2,
                                                    )
                                                  : Colors.grey.withValues(
                                                      alpha: .1,
                                                    ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Icon(
                                                playerVM.repeatMode ==
                                                        RepeatPlayerMode
                                                            .repeatAll
                                                    ? CupertinoIcons.repeat
                                                    : playerVM.repeatMode ==
                                                          RepeatPlayerMode
                                                              .repeatOne
                                                    ? CupertinoIcons.repeat_1
                                                    : CupertinoIcons.shuffle,
                                                size: 25,
                                                color:
                                                    playerVM
                                                            .currentItem
                                                            ?.artUri !=
                                                        null
                                                    ? Colors.white
                                                    : Theme.brightnessOf(
                                                            context,
                                                          ) ==
                                                          .dark
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                  ),
                                ),
                                Spacer(),
                                const AudioControlsPlayer(),
                                Spacer(),
                                SizedBox(
                                  width: 45,
                                  height: 45,
                                  child: Consumer<PlayerViewModel>(
                                    builder: (context, playerVM, child) =>
                                        GestureDetector(
                                          onTap: () => openQueue(context),
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              color:
                                                  playerVM
                                                          .currentItem
                                                          ?.artUri !=
                                                      null
                                                  ? Colors.white.withValues(
                                                      alpha: .15,
                                                    )
                                                  : Theme.brightnessOf(
                                                          context,
                                                        ) ==
                                                        .dark
                                                  ? Colors.white.withValues(
                                                      alpha: .2,
                                                    )
                                                  : Colors.grey.withValues(
                                                      alpha: .1,
                                                    ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Icon(
                                                CupertinoIcons.music_albums,
                                                size: 25,
                                                color:
                                                    playerVM
                                                            .currentItem
                                                            ?.artUri !=
                                                        null
                                                    ? Colors.white
                                                    : Theme.brightnessOf(
                                                            context,
                                                          ) ==
                                                          .dark
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void openQueue(BuildContext context) {
    Get.bottomSheet(const QueuePlayer());
  }
}
