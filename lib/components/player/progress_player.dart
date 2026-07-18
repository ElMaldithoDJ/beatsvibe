import 'package:beatsvibe/vm/player_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgressPlayer extends StatefulWidget {
  const ProgressPlayer({super.key});

  @override
  State<ProgressPlayer> createState() => _ProgressPlayerState();
}

class _ProgressPlayerState extends State<ProgressPlayer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerViewModel>(
      builder: (context, playerVM, child) {
        return Column(
          children: [
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 3,
                thumbColor: Colors.white,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                trackShape: const RoundedRectSliderTrackShape(),
                inactiveTrackColor: Colors.white.withValues(alpha: .2),
                overlayColor: Colors.transparent,
                activeTrackColor: Colors.white,
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
                  Text(
                    playerVM.currentPositionString,
                    style: TextStyle(
                      color: playerVM.currentItem?.artUri != null
                          ? Colors.white
                          : Theme.brightnessOf(context) == .dark
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ),
                  Spacer(),
                  Text(
                    playerVM.durationString,
                    style: TextStyle(
                      color: playerVM.currentItem?.artUri != null
                          ? Colors.white
                          : Theme.brightnessOf(context) == .dark
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
