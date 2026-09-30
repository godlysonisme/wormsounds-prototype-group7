import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/game_constants.dart';

// Shared pieces used by the title and end level screens,
// so they look the same as the level itself.

// The tiled cloud background from the level, with faint
// staff lines across it.
class SkyBackground extends StatelessWidget {
  const SkyBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: GameConstants.backgroundColor,
        image: DecorationImage(
          image: AssetImage('assets/images/BG.png'),
          repeat: ImageRepeat.repeat,
          alignment: Alignment.topLeft,
          // Keep the pixel art crisp.
          filterQuality: FilterQuality.none,
        ),
      ),
      child: CustomPaint(
        painter: _StaffLinesPainter(),
        child: SafeArea(child: child),
      ),
    );
  }
}

class _StaffLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = GameConstants.staffColor.withValues(alpha: 0.35);

    const spacing = 40.0;
    final bottom = size.height * GameConstants.staffVerticalPosition;

    for (int i = 0; i < 5; i++) {
      final y = bottom - (i * spacing);
      canvas.drawRect(
        Rect.fromLTWH(
          GameConstants.staffSidePadding,
          y,
          size.width - (GameConstants.staffSidePadding * 2),
          GameConstants.staffLineThickness,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Dark see-through panel, like the phase text in the level.
class GamePanel extends StatelessWidget {
  const GamePanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: GameConstants.panelColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

// Small grey heading used above values in panels.
class PanelLabel extends StatelessWidget {
  const PanelLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFFE0E0E0),
        fontSize: 12,
        letterSpacing: 1.5,
      ),
    );
  }
}

// Chunky button with a black outline, coloured like
// the LISTEN / PLAY banners.
class GameButton extends StatelessWidget {
  const GameButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = GameConstants.listenAmber,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          color: GameConstants.pianoBlack,
          width: 3,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: GameConstants.pianoBlack),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(
                  color: GameConstants.pianoBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// The worm sprite, flapping its wing.
class FlappingWorm extends StatefulWidget {
  const FlappingWorm({super.key, this.size = 96});

  final double size;

  @override
  State<FlappingWorm> createState() => _FlappingWormState();
}

class _FlappingWormState extends State<FlappingWorm> {
  bool _wingUp = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(milliseconds: 300),
          (_) => setState(() => _wingUp = !_wingUp),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _wingUp ? 'assets/images/WormFlap.png' : 'assets/images/Worm.png',
      width: widget.size,
      height: widget.size,
      fit: BoxFit.contain,
      // Keep the pixel art crisp, and avoid flicker when swapping frames.
      filterQuality: FilterQuality.none,
      gaplessPlayback: true,
    );
  }
}

// Fades between screens instead of sliding.
Route<void> fadeRoute(Widget page) {
  return PageRouteBuilder<void>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}