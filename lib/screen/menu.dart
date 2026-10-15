import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/game_constants.dart';
import '../game/difficulty.dart';
import '../game/highscore.dart';
import '../game/level.dart';
import '../game/levelresult.dart';
import '../game/notesounds.dart';

import 'level_select.dart';
import 'screen_widgets.dart';
import 'test_level.dart';

// Title screen: shows the high score, lets the player
// choose a normal level or Endless Mode, select a
// difficulty, and start the game.
class TitleScreen extends StatefulWidget {
  const TitleScreen({
    super.key,
    this.initialLevel = GameLevel.one,
    this.initialDifficulty = Difficulty.normal,
  });

  final GameLevel initialLevel;
  final Difficulty initialDifficulty;

  @override
  State<TitleScreen> createState() =>
      _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {
  late GameLevel _level =
      widget.initialLevel;

  late Difficulty _difficulty =
      widget.initialDifficulty;

  // High score for the currently selected
  // level or Endless Mode.
  int? _highScore;

  @override
  void initState() {
    super.initState();

    // Start loading the note sounds now
    // so they are ready when the game starts.
    unawaited(
      NoteSounds.shared.load(),
    );

    _loadHighScore();
  }

  // ------------------------------------------------------------
  // HIGH SCORE
  // ------------------------------------------------------------

  void _loadHighScore() {
    final level = _level;

    HighScore.load(
      level,
    ).then(
          (highScore) {
        // Ignore the result if the player
        // changed modes while it was loading.
        if (!mounted ||
            level != _level) {
          return;
        }

        setState(() {
          _highScore = highScore;
        });
      },
    );
  }

  // ------------------------------------------------------------
  // LEVEL SELECTION
  // ------------------------------------------------------------

  void _selectLevel(
      GameLevel level,
      ) {
    if (level == _level) {
      return;
    }

    setState(() {
      _level = level;
      _highScore = null;
    });

    _loadHighScore();
  }

  // Opens the separate scrollable
  // level-selection screen.
  Future<void> _openLevelSelect() async {
    // Endless Mode isn't one of the numbered
    // teaching levels, so Level 1 is highlighted
    // when opening the page from Endless Mode.
    final currentNormalLevel =
    _level == GameLevel.endless
        ? GameLevel.one
        : _level;

    final selectedLevel =
    await Navigator.of(context)
        .push<GameLevel>(
      MaterialPageRoute<GameLevel>(
        builder: (context) {
          return LevelSelectScreen(
            currentLevel:
            currentNormalLevel,
          );
        },
      ),
    );

    // Pressing the back button returns null.
    if (selectedLevel == null ||
        !mounted) {
      return;
    }

    _selectLevel(
      selectedLevel,
    );
  }

  // ------------------------------------------------------------
  // START GAME
  // ------------------------------------------------------------

  void _start() {
    Navigator.of(context)
        .pushReplacement(
      fadeRoute(
        TestLevel(
          level: _level,
          difficulty: _difficulty,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // MAIN SCREEN
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SkyBackground(
        child: LayoutBuilder(
          builder: (
              context,
              constraints,
              ) {
            final bool isLandscape =
                constraints.maxWidth >
                    constraints.maxHeight;

            final title =
            _buildTitle(
              isLandscape,
            );

            final highScore =
            _buildHighScore();

            final controls =
            _buildControls();

            // In landscape the title and
            // high score stay on the left,
            // with the controls on the right.
            if (isLandscape) {
              return Center(
                child:
                SingleChildScrollView(
                  padding:
                  const EdgeInsets.all(
                    16,
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisSize:
                          MainAxisSize
                              .min,
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .stretch,
                          children: [
                            title,

                            const SizedBox(
                              height: 14,
                            ),

                            highScore,
                          ],
                        ),
                      ),

                      const SizedBox(
                        width: 24,
                      ),

                      Flexible(
                        child: controls,
                      ),
                    ],
                  ),
                ),
              );
            }

            // Portrait layout.
            return Center(
              child:
              SingleChildScrollView(
                padding:
                const EdgeInsets.all(
                  24,
                ),
                child: ConstrainedBox(
                  constraints:
                  const BoxConstraints(
                    maxWidth: 420,
                  ),
                  child: Column(
                    mainAxisSize:
                    MainAxisSize.min,
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .stretch,
                    children: [
                      title,

                      const SizedBox(
                        height: 24,
                      ),

                      highScore,

                      const SizedBox(
                        height: 14,
                      ),

                      controls,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // TITLE
  // ------------------------------------------------------------

  Widget _buildTitle(
      bool isLandscape,
      ) {
    return GamePanel(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 18,
      ),
      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          FlappingWorm(
            size:
            isLandscape
                ? 80
                : 110,
          ),

          const SizedBox(
            height: 8,
          ),

          const Text(
            'WORM SOUNDS',
            textAlign:
            TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight:
              FontWeight.bold,
              letterSpacing: 3,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          const Text(
            'Train your ear, one note at a time.',
            textAlign:
            TextAlign.center,
            style: TextStyle(
              color:
              Color(0xFFE0E0E0),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // HIGH SCORE
  // ------------------------------------------------------------

  Widget _buildHighScore() {
    return GamePanel(
      child: Column(
        children: [
          PanelLabel(
            '${_level.label} HIGH SCORE',
          ),

          const SizedBox(
            height: 2,
          ),

          Text(
            _highScore == null
                ? '...'
                : formatScore(
              _highScore!,
            ),
            style:
            const TextStyle(
              color:
              GameConstants
                  .listenAmber,
              fontSize: 28,
              fontWeight:
              FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // CONTROLS
  // ------------------------------------------------------------

  Widget _buildControls() {
    return Column(
      mainAxisSize:
      MainAxisSize.min,
      crossAxisAlignment:
      CrossAxisAlignment.stretch,
      children: [
        // --------------------------------------------------------
        // GAME MODE
        // --------------------------------------------------------

        GamePanel(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .stretch,
            children: [
              const PanelLabel(
                'GAME MODE',
              ),

              const SizedBox(
                height: 10,
              ),

              // Opens the separate
              // Level Select page.
              GameButton(
                label: 'LEVELS',
                icon:
                Icons.queue_music,
                onPressed:
                _openLevelSelect,
              ),

              const SizedBox(
                height: 8,
              ),

              // Show which numbered
              // level is currently selected.
              Center(
                child: Text(
                  _level !=
                      GameLevel
                          .endless
                      ? 'Selected: ${_level.label}'
                      : 'Choose a teaching level',
                  textAlign:
                  TextAlign.center,
                  style:
                  TextStyle(
                    color:
                    _level !=
                        GameLevel
                            .endless
                        ? GameConstants
                        .listenAmber
                        : const Color(
                      0xFFE0E0E0,
                    ),
                    fontSize: 12,
                    fontWeight:
                    _level !=
                        GameLevel
                            .endless
                        ? FontWeight
                        .bold
                        : FontWeight
                        .normal,
                  ),
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              // Endless stays separate
              // from the teaching levels.
              GameButton(
                label:
                'ENDLESS MODE',
                icon:
                Icons.all_inclusive,
                color:
                GameConstants
                    .playOrange,
                onPressed: () {
                  _selectLevel(
                    GameLevel.endless,
                  );
                },
              ),

              if (_level ==
                  GameLevel
                      .endless) ...[
                const SizedBox(
                  height: 8,
                ),

                const Center(
                  child: Text(
                    'Selected: ENDLESS MODE',
                    textAlign:
                    TextAlign.center,
                    style:
                    TextStyle(
                      color:
                      GameConstants
                          .listenAmber,
                      fontSize: 12,
                      fontWeight:
                      FontWeight
                          .bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        // --------------------------------------------------------
        // DIFFICULTY
        // Endless Mode doesn't use difficulty.
        // --------------------------------------------------------

        if (_level !=
            GameLevel.endless) ...[
          const SizedBox(
            height: 14,
          ),

          GamePanel(
            child: Column(
              children: [
                const PanelLabel(
                  'DIFFICULTY',
                ),

                const SizedBox(
                  height: 10,
                ),

                Row(
                  children: [
                    for (final difficulty
                    in Difficulty
                        .values) ...[
                      if (difficulty !=
                          Difficulty
                              .values
                              .first)
                        const SizedBox(
                          width: 8,
                        ),

                      Expanded(
                        child:
                        _SelectorOption(
                          label:
                          difficulty
                              .label,
                          isSelected:
                          difficulty ==
                              _difficulty,
                          onTap: () {
                            setState(
                                  () {
                                _difficulty =
                                    difficulty;
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(
                  height: 8,
                ),

                Text(
                  _difficulty
                      .description,
                  textAlign:
                  TextAlign.center,
                  style:
                  const TextStyle(
                    color:
                    Color(
                      0xFFE0E0E0,
                    ),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],

        // --------------------------------------------------------
        // START
        // --------------------------------------------------------

        const SizedBox(
          height: 18,
        ),

        GameButton(
          label:
          _level ==
              GameLevel
                  .endless
              ? 'START ENDLESS'
              : 'START',
          icon:
          Icons.play_arrow,
          onPressed:
          _start,
        ),
      ],
    );
  }
}

// ============================================================
// EASY / NORMAL / HARD SELECTOR
// ============================================================

class _SelectorOption
    extends StatelessWidget {
  const _SelectorOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(
      BuildContext context,
      ) {
    return Material(
      color:
      isSelected
          ? GameConstants
          .listenAmber
          : Colors.transparent,

      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(
          8,
        ),
        side: BorderSide(
          color:
          isSelected
              ? GameConstants
              .pianoBlack
              : const Color(
            0x88FFFFFF,
          ),
          width: 2,
        ),
      ),

      clipBehavior:
      Clip.antiAlias,

      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding:
          const EdgeInsets
              .symmetric(
            vertical: 10,
            horizontal: 4,
          ),
          child: Center(
            child: FittedBox(
              fit:
              BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style:
                TextStyle(
                  color:
                  isSelected
                      ? GameConstants
                      .pianoBlack
                      : Colors
                      .white,
                  fontSize: 14,
                  fontWeight:
                  FontWeight
                      .bold,
                  letterSpacing:
                  1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}