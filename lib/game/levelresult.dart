import 'package:wormsounds/game/difficulty.dart';
import 'package:wormsounds/game/level.dart';

// Everything the end level screen needs to know
// about how the player did.
class LevelResult {
  final int score;

  // The score a perfect run would have got.
  final int maxScore;

  final int notesHit;
  final int notesTotal;

  final Difficulty difficulty;

  // Which level was played, so RESTART plays the same one.
  final GameLevel level;

  const LevelResult({
    required this.score,
    required this.maxScore,
    required this.notesHit,
    required this.notesTotal,
    required this.difficulty,
    this.level = GameLevel.one,
  });

  // Score as a percentage of a perfect run.
  double get percent =>
      maxScore == 0 ? 0 : (score / maxScore) * 100;

  // A level with no scored notes (e.g. a placeholder
  // level) has nothing to rate, so it shows a dash.
  String get rating =>
      maxScore == 0 ? '-' : difficulty.ratingFor(percent);
}

// Adds commas to a score, e.g. 9750 -> "9,750".
String formatScore(int score) {
  final digits = score.toString();
  final buffer = StringBuffer();

  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[i]);
  }

  return buffer.toString();
}