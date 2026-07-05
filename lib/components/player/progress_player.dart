import 'package:beatsvibe/vm/player_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgressPlayer extends StatelessWidget {
  const ProgressPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerViewModel>(
      builder: (context, playerVM, child) {
        return Column(
          children: [
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 3,
                thumbColor: Theme.brightnessOf(context) == .dark
                    ? Colors.white
                    : Theme.of(context).primaryColor,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
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
          ],
        );
      },
    );
  }
}
