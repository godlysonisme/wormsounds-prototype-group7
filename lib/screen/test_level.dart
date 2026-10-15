import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../constants/game_constants.dart';
import '../game/difficulty.dart';
import '../game/highscore.dart';
import '../game/keys.dart';
import '../game/level.dart';
import '../game/levelresult.dart';
import '../game/vibratobutton.dart';
import '../game/worm_sounds_game.dart';

import 'end_level.dart';
import 'menu.dart';
import 'pause_overlay.dart';
import 'screen_widgets.dart';

class TestLevel extends StatefulWidget {
  const TestLevel({
    super.key,
    this.level = GameLevel.one,
    this.difficulty = Difficulty.normal,
  });

  final GameLevel level;

  // Only changes how strict the rating
  // at the end is.
  final Difficulty difficulty;

  @override
  State<TestLevel> createState() =>
      _TestLevelState();
}

class _TestLevelState
    extends State<TestLevel> {
  late final WormSoundsGame game;

  bool _hasEnded = false;

  bool _isPaused = false;

  @override
  void initState() {
    super.initState();

    game = WormSoundsGame(
      level: widget.level,
      difficulty: widget.difficulty,
      onLevelComplete: _showEndScreen,
    );
  }

  // ------------------------------------------------------------
  // LEVEL COMPLETE
  // ------------------------------------------------------------

  void _showEndScreen(
      LevelResult result,
      ) {
    if (_hasEnded) {
      return;
    }

    _hasEnded = true;

    WidgetsBinding.instance
        .addPostFrameCallback(
          (_) {
        if (!mounted) {
          return;
        }

        Navigator.of(context)
            .pushReplacement(
          fadeRoute(
            EndLevelScreen(
              result: result,
            ),
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // PAUSE
  // ------------------------------------------------------------

  void _pauseGame() {
    if (_isPaused || _hasEnded) {
      return;
    }

    // Stop Flame's entire game loop.
    game.pauseEngine();

    // Vibrato should not stay active
    // while the game is paused.
    game.setVibrato(false);

    setState(() {
      _isPaused = true;
    });
  }

  // ------------------------------------------------------------
  // RESUME
  // ------------------------------------------------------------

  void _resumeGame() {
    if (!_isPaused) {
      return;
    }

    setState(() {
      _isPaused = false;
    });

    game.resumeEngine();
  }

  // ------------------------------------------------------------
  // EXIT
  // ------------------------------------------------------------

  Future<void> _exitLevel() async {
    if (_hasEnded) {
      return;
    }

    _hasEnded = true;

    // Endless never reaches the normal
    // end-level screen, so save its score
    // when the player chooses to leave.
    if (widget.level ==
        GameLevel.endless) {
      final previousHighScore =
      await HighScore.load(
        GameLevel.endless,
      );

      if (game.score >
          previousHighScore) {
        await HighScore.save(
          GameLevel.endless,
          game.score,
        );
      }
    }

    if (!mounted) {
      return;
    }

    Navigator.of(context)
        .pushReplacement(
      fadeRoute(
        TitleScreen(
          initialLevel:
          widget.level,
          initialDifficulty:
          widget.difficulty,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      GameConstants.backgroundColor,

      body: Stack(
        children: [
          // ------------------------------------------------
          // GAME + CONTROLS
          // ------------------------------------------------

          Positioned.fill(
            child: AbsorbPointer(
              absorbing:
              _isPaused,

              child: OrientationBuilder(
                builder: (
                    context,
                    orientation,
                    ) {
                  final bool
                  isLandscape =
                      orientation ==
                          Orientation
                              .landscape;

                  final double
                  keyboardHeight =
                  isLandscape
                      ? GameConstants
                      .pianoKeyHeightLandscape
                      : GameConstants
                      .pianoKeyHeightPortrait;

                  final double
                  vibratoBarHeight =
                  isLandscape
                      ? GameConstants
                      .vibratoBarHeightLandscape
                      : GameConstants
                      .vibratoBarHeightPortrait;

                  return Column(
                    children: [
                      Expanded(
                        child:
                        GameWidget(
                          game: game,
                        ),
                      ),

                      VibratoButton(
                        height:
                        vibratoBarHeight,
                        onChanged:
                        game.setVibrato,
                      ),

                      PianoKeys(
                        height:
                        keyboardHeight,
                        onNotePressed:
                        game
                            .moveWormToNote,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // ------------------------------------------------
          // PAUSE BUTTON
          // ------------------------------------------------

          if (!_isPaused &&
              !_hasEnded)
            SafeArea(
              child: Align(
                alignment:
                Alignment.topLeft,
                child: Padding(
                  padding:
                  const EdgeInsets.all(
                    12,
                  ),
                  child: PauseButton(
                    onPressed:
                    _pauseGame,
                  ),
                ),
              ),
            ),

          // ------------------------------------------------
          // PAUSE MENU
          // ------------------------------------------------

          if (_isPaused)
            Positioned.fill(
              child: PauseOverlay(
                onResume:
                _resumeGame,
                onExit: () {
                  _exitLevel();
                },
              ),
            ),
        ],
      ),
    );
  }
}