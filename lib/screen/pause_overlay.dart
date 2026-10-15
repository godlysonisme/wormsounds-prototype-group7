import 'package:flutter/material.dart';

import '../constants/game_constants.dart';
import 'screen_widgets.dart';

class PauseButton extends StatelessWidget {
  const PauseButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: GameConstants.panelColor,
      shape: const CircleBorder(
        side: BorderSide(
          color: Colors.white,
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: const SizedBox(
          width: 52,
          height: 52,
          child: Icon(
            Icons.pause_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}

class PauseOverlay extends StatelessWidget {
  const PauseOverlay({
    super.key,
    required this.onResume,
    required this.onExit,
  });

  final VoidCallback onResume;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(
        alpha: 0.65,
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 320,
          ),
          child: GamePanel(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.pause_circle_outline,
                  color:
                  GameConstants.listenAmber,
                  size: 58,
                ),

                const SizedBox(height: 10),

                const Text(
                  'PAUSED',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 24),

                GameButton(
                  label: 'RESUME',
                  icon: Icons.play_arrow,
                  onPressed: onResume,
                ),

                const SizedBox(height: 12),

                GameButton(
                  label: 'EXIT TO MENU',
                  icon: Icons.home,
                  color:
                  GameConstants.playOrange,
                  onPressed: onExit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}