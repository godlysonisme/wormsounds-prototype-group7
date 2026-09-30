import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/game_constants.dart';
import '../game/difficulty.dart';
import '../game/highscore.dart';
import '../game/levelresult.dart';
import '../game/notesounds.dart';
import 'screen_widgets.dart';
import 'test_level.dart';

// Title screen: shows the high score, lets the player pick a
// difficulty (how strict the end rating is) and start the level.
class TitleScreen extends StatefulWidget {
  const TitleScreen({
    super.key,
    this.initialDifficulty = Difficulty.normal,
  });

  final Difficulty initialDifficulty;

  @override
  State<TitleScreen> createState() =>
      _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {
  late Difficulty _difficulty = widget.initialDifficulty;

  int? _highScore;

  @override
  void initState() {
    super.initState();

    // Start loading the note sounds now so they are
    // ready as soon as the level starts.
    unawaited(NoteSounds.shared.load());

    HighScore.load().then((highScore) {
      if (!mounted) return;
      setState(() => _highScore = highScore);
    });
  }

  void _start() {
    Navigator.of(context).pushReplacement(
      fadeRoute(
        TestLevel(difficulty: _difficulty),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SkyBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isLandscape =
                constraints.maxWidth > constraints.maxHeight;

            final title = _buildTitle(isLandscape);
            final controls = _buildControls();

            if (isLandscape) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(child: title),
                      const SizedBox(width: 24),
                      Flexible(child: controls),
                    ],
                  ),
                ),
              );
            }

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      title,
                      const SizedBox(height: 24),
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

  Widget _buildTitle(bool isLandscape) {
    return GamePanel(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FlappingWorm(size: isLandscape ? 80 : 110),
          const SizedBox(height: 8),
          const Text(
            'WORM SOUNDS',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Train your ear, one note at a time.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFE0E0E0),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GamePanel(
          child: Column(
            children: [
              const PanelLabel('HIGH SCORE'),
              const SizedBox(height: 2),
              Text(
                _highScore == null ? '...' : formatScore(_highScore!),
                style: const TextStyle(
                  color: GameConstants.listenAmber,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        GamePanel(
          child: Column(
            children: [
              const PanelLabel('DIFFICULTY'),
              const SizedBox(height: 10),
              Row(
                children: [
                  for (final difficulty in Difficulty.values) ...[
                    if (difficulty != Difficulty.values.first)
                      const SizedBox(width: 8),
                    Expanded(
                      child: _DifficultyOption(
                        difficulty: difficulty,
                        isSelected: difficulty == _difficulty,
                        onTap: () => setState(() => _difficulty = difficulty),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _difficulty.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFE0E0E0),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        GameButton(
          label: 'START',
          icon: Icons.play_arrow,
          onPressed: _start,
        ),
      ],
    );
  }
}

// One of the EASY / NORMAL / HARD buttons.
class _DifficultyOption extends StatelessWidget {
  const _DifficultyOption({
    required this.difficulty,
    required this.isSelected,
    required this.onTap,
  });

  final Difficulty difficulty;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? GameConstants.listenAmber
          : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected
              ? GameConstants.pianoBlack
              : const Color(0x88FFFFFF),
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              difficulty.label,
              style: TextStyle(
                color: isSelected
                    ? GameConstants.pianoBlack
                    : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}