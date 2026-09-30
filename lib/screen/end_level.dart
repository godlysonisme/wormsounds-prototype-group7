import 'package:flutter/material.dart';

import '../constants/game_constants.dart';
import '../game/difficulty.dart';
import '../game/highscore.dart';
import '../game/levelresult.dart';
import 'menu.dart';
import 'screen_widgets.dart';
import 'test_level.dart';

// Shown when the level ends: the rating, score, high score,
// and buttons to play again or go back to the title screen.
class EndLevelScreen extends StatefulWidget {
  const EndLevelScreen({super.key, required this.result});

  final LevelResult result;

  @override
  State<EndLevelScreen> createState() =>
      _EndLevelScreenState();
}

class _EndLevelScreenState extends State<EndLevelScreen> {
  int? _highScore;
  bool _isNewHighScore = false;

  @override
  void initState() {
    super.initState();
    _updateHighScore();
  }

  // Save this score if it beats the old high score.
  Future<void> _updateHighScore() async {
    final previous = await HighScore.load();
    final isNew = widget.result.score > previous;

    if (isNew) {
      await HighScore.save(widget.result.score);
    }

    if (!mounted) return;

    setState(() {
      _highScore = isNew ? widget.result.score : previous;
      _isNewHighScore = isNew;
    });
  }

  void _restart() {
    Navigator.of(context).pushReplacement(
      fadeRoute(
        TestLevel(difficulty: widget.result.difficulty),
      ),
    );
  }

  void _backToTitle() {
    Navigator.of(context).pushReplacement(
      fadeRoute(
        TitleScreen(initialDifficulty: widget.result.difficulty),
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

            const header = GamePanel(
              child: Text(
                'LEVEL COMPLETE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            );

            final rating = _buildRating(isLandscape ? 96 : 120);
            final stats = _buildStats();
            final buttons = _buildButtons();

            if (isLandscape) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            header,
                            const SizedBox(height: 14),
                            rating,
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            stats,
                            const SizedBox(height: 14),
                            buttons,
                          ],
                        ),
                      ),
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
                      header,
                      const SizedBox(height: 14),
                      rating,
                      const SizedBox(height: 14),
                      stats,
                      const SizedBox(height: 18),
                      buttons,
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

  // Big letter rating in a badge, coloured by how well they did.
  Widget _buildRating(double badgeSize) {
    final rating = widget.result.rating;

    return GamePanel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PanelLabel('RATING'),
          const SizedBox(height: 8),
          Container(
            width: badgeSize,
            height: badgeSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _ratingColour(rating),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: GameConstants.pianoBlack,
                width: 3,
              ),
            ),
            child: Text(
              rating,
              style: TextStyle(
                color: GameConstants.pianoBlack,
                fontSize: badgeSize * 0.45,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _ratingColour(String rating) {
    switch (rating) {
      case 'A+':
      case 'A':
        return GameConstants.listenAmber;
      case 'B':
        return const Color(0xFF8BC34A);
      case 'C':
      case 'D':
        return GameConstants.playOrange;
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  Widget _buildStats() {
    final result = widget.result;

    return GamePanel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatRow(
            label: 'SCORE',
            value: formatScore(result.score),
            valueColour: GameConstants.listenAmber,
            large: true,
          ),
          _StatRow(
            label: 'HIGH SCORE',
            value: _highScore == null ? '...' : formatScore(_highScore!),
          ),
          if (_isNewHighScore)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: GameConstants.listenAmber,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'NEW HIGH SCORE!',
                  style: TextStyle(
                    color: GameConstants.pianoBlack,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          _StatRow(
            label: 'NOTES HIT',
            value: '${result.notesHit} / ${result.notesTotal}',
          ),
          _StatRow(
            label: 'DIFFICULTY',
            value: result.difficulty.label,
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GameButton(
          label: 'RESTART',
          icon: Icons.replay,
          onPressed: _restart,
        ),
        const SizedBox(height: 10),
        GameButton(
          label: 'TITLE SCREEN',
          icon: Icons.home,
          color: GameConstants.playOrange,
          onPressed: _backToTitle,
        ),
      ],
    );
  }
}

// One line of the stats panel, e.g. "SCORE ....... 8,420".
class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    this.valueColour = Colors.white,
    this.large = false,
  });

  final String label;
  final String value;
  final Color valueColour;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          PanelLabel(label),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: valueColour,
              fontSize: large ? 24 : 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}