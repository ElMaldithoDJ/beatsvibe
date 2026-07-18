import 'package:beatsvibe/vm/player_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgressPlayer extends StatefulWidget {
  const ProgressPlayer({super.key});

  @override
  State<ProgressPlayer> createState() => _ProgressPlayerState();
}

class _ProgressPlayerState extends State<ProgressPlayer> {
  bool _isDragging = false;
  double _dragValue = 0.0;

  String _formatDuration(Duration duration) {
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerViewModel>(
      builder: (context, playerVM, child) {
        final double maxDuration = playerVM.duration.inSeconds.toDouble();
        // Ensure max is always at least 0.1 to avoid errors when duration is zero
        final double sliderMax = maxDuration > 0 ? maxDuration : 0.1;
        
        // Ensure the value is within the min and max bounds
        double sliderValue = _isDragging
            ? _dragValue
            : (playerVM.progress * maxDuration);
            
        if (sliderValue < 0) sliderValue = 0;
        if (sliderValue > sliderMax) sliderValue = sliderMax;

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
                max: sliderMax,
                value: sliderValue,
                onChangeStart: (value) {
                  setState(() {
                    _isDragging = true;
                    _dragValue = value;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    _dragValue = value;
                  });
                },
                onChangeEnd: (value) {
                  playerVM.seek(Duration(seconds: value.toInt()));
                  setState(() {
                    _isDragging = false;
                  });
                },
              ),
            ),
            Padding(
              padding: const .symmetric(horizontal: 30),
              child: Row(
                children: [
                  Text(
                    _isDragging
                        ? _formatDuration(Duration(seconds: _dragValue.toInt()))
                        : playerVM.currentPositionString,
                    style: TextStyle(color: Colors.white),
                  ),
                  Spacer(),
                  Text(
                    playerVM.durationString,
                    style: TextStyle(color: Colors.white),
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
