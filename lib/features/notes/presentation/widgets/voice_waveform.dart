import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Animated fake waveform bars shown during voice recording.
class VoiceWaveform extends StatefulWidget {
  const VoiceWaveform({super.key, this.isActive = false});
  final bool isActive;

  @override
  State<VoiceWaveform> createState() => _VoiceWaveformState();
}

class _VoiceWaveformState extends State<VoiceWaveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(7, (i) {
            final phase = (_ctrl.value + i * 0.12) % 1.0;
            final height = 8.0 + phase * 18 + _rng.nextDouble() * 4;
            return Container(
              width: 3.5,
              height: height.clamp(6.0, 28.0),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.electricBlue,
                    AppColors.neonPurple,
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
