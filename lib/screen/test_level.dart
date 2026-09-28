import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/keys.dart';
import '../game/worm_sounds_game.dart';

class TestLevel extends StatefulWidget {
  const TestLevel({super.key});

  @override
  State<TestLevel> createState() =>
      _TestLevelState();
}

class _TestLevelState
    extends State<TestLevel> {
  late final WormSoundsGame game;

  @override
  void initState() {
    super.initState();

    game = WormSoundsGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFF87CEEB),
      body: SafeArea(
        child: Column(
          children: [
            // Flame controls everything
            // inside this gameplay area.
            Expanded(
              child: GameWidget(
                game: game,
              ),
            ),

            // Flutter controls the piano UI.
            PianoKeys(
              onNotePressed:
              game.moveWormToNote,
            ),
          ],
        ),
      ),
    );
  }
}