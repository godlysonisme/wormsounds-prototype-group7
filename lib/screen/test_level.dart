import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../constants/game_constants.dart';
import '../game/difficulty.dart';
import '../game/keys.dart';
import '../game/levelresult.dart';
import '../game/vibratobutton.dart';
import '../game/worm_sounds_game.dart';
import 'end_level.dart';
import 'screen_widgets.dart';

class TestLevel extends StatefulWidget {
  const TestLevel({
    super.key,
    this.difficulty = Difficulty.normal,
  });

  // Only changes how strict the rating at the end is.
  final Difficulty difficulty;

  @override
  State<TestLevel> createState() =>
      _TestLevelState();
}

class _TestLevelState extends State<TestLevel> {
  late final WormSoundsGame game;

  @override
  void initState() {
    super.initState();

    game = WormSoundsGame(
      difficulty: widget.difficulty,
      onLevelComplete: _showEndScreen,
    );
  }

  bool _hasEnded = false;

  void _showEndScreen(LevelResult result) {
    if (_hasEnded) return;
    _hasEnded = true;

    // Wait until the current frame has finished before
    // changing screens, as this is called from the game loop.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        fadeRoute(
          EndLevelScreen(result: result),
        ),
      );
    });
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

          final double vibratoBarHeight =
          isLandscape
              ? GameConstants
              .vibratoBarHeightLandscape
              : GameConstants
              .vibratoBarHeightPortrait;

          return Column(
            children: [
              Expanded(
                child: GameWidget(
                  game: game,
                ),
              ),

              VibratoButton(
                height: vibratoBarHeight,
                onChanged:
                game.setVibrato,
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