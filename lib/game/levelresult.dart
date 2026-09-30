import 'package:wormsounds/game/difficulty.dart';

// Everything the end level screen needs to know
// about how the player did.
class LevelResult {
  final int score;

  // The score a perfect run would have got.
  final int maxScore;

  final int notesHit;
  final int notesTotal;

  final Difficulty difficulty;

  const LevelResult({
    required this.score,
    required this.maxScore,
    required this.notesHit,
    required this.notesTotal,
    required this.difficulty,
  });

  // Score as a percentage of a perfect run.
  double get percent =>
      maxScore == 0 ? 0 : (score / maxScore) * 100;

  String get rating =>
      difficulty.ratingFor(percent);
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