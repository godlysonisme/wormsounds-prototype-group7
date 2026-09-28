import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../constants/game_constants.dart';
import '../game/keys.dart';
import '../game/worm_sounds_game.dart';

class TestLevel extends StatefulWidget {
  const TestLevel({super.key});

  @override
  State<TestLevel> createState() =>
      _TestLevelState();
}

class _TestLevelState extends State<TestLevel> {
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
      GameConstants.backgroundColor,
      body: OrientationBuilder(
        builder: (context, orientation) {
          final bool isLandscape =
              orientation ==
                  Orientation.landscape;

          final double keyboardHeight =
          isLandscape
              ? GameConstants
              .pianoKeyHeightLandscape
              : GameConstants
              .pianoKeyHeightPortrait;

          return Column(
            children: [
              Expanded(
                child: GameWidget(
                  game: game,
                ),
              ),

              PianoKeys(
                height: keyboardHeight,
                onNotePressed:
                game.moveWormToNote,
              ),
            ],
          );
        },
      ),
    );
  }
}