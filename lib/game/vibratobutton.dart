import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants/game_constants.dart';

// A bar above the keys that the player holds down to add
// vibrato to the notes they hit. It lights up and its wave
// icon wiggles while held.
class VibratoButton extends StatefulWidget {
  const VibratoButton({
    super.key,
    required this.onChanged,
    required this.height,
  });

  final ValueChanged<bool> onChanged;
  final double height;

  @override
  State<VibratoButton> createState() =>
      _VibratoButtonState();
}

class _VibratoButtonState extends State<VibratoButton>
    with SingleTickerProviderStateMixin {
  // Counts fingers on the bar, so lifting one of two
  // fingers doesn't switch vibrato off.
  int _pointersDown = 0;

  bool get _isActive => _pointersDown > 0;

  late final AnimationController _wiggle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
  );

  void _pointerDown(PointerDownEvent event) {
    _pointersDown++;

    if (_pointersDown == 1) {
      _wiggle.repeat(reverse: true);
      widget.onChanged(true);
    }

    setState(() {});
  }

  void _pointerUp(PointerEvent event) {
    if (_pointersDown == 0) return;

    _pointersDown--;

    if (_pointersDown == 0) {
      _wiggle.stop();
      _wiggle.value = 0.5;
      widget.onChanged(false);
    }

    setState(() {});
  }

  @override
  void dispose() {
    _wiggle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _isActive
        ? GameConstants.pianoBlack
        : GameConstants.pianoWhite;

    // Raw pointer events (not a normal button), so the bar can
    // be held with one finger while other fingers tap the keys.
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: _pointerDown,
      onPointerUp: _pointerUp,
      onPointerCancel: _pointerUp,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: widget.height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: _isActive
              ? GameConstants.listenAmber
              : GameConstants.vibratoBarColor,
          border: const Border(
            top: BorderSide(
              color: GameConstants.pianoBlack,
              width: 2,
            ),
          ),
          boxShadow: _isActive
              ? [
            BoxShadow(
              color: GameConstants.listenAmber.withValues(alpha: 0.7),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _wiggle,
              builder: (context, child) {
                // Wiggle the wave icon side to side while held.
                final offset = _isActive
                    ? math.sin(_wiggle.value * math.pi * 2) * 4
                    : 0.0;

                return Transform.translate(
                  offset: Offset(offset, 0),
                  child: child,
                );
              },
              child: Icon(
                Icons.waves,
                color: textColor,
                size: widget.height * 0.5,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              _isActive ? 'VIBRATO ON' : 'HOLD FOR VIBRATO',
              style: TextStyle(
                color: textColor,
                fontSize: widget.height < 45 ? 14 : 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}