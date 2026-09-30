// The difficulty only changes how strict the rating at the
// end of the level is. The level itself plays the same.
enum Difficulty {
  easy,
  normal,
  hard,
}

extension DifficultyRating on Difficulty {
  String get label {
    switch (this) {
      case Difficulty.easy:
        return 'EASY';
      case Difficulty.normal:
        return 'NORMAL';
      case Difficulty.hard:
        return 'HARD';
    }
  }

  String get description {
    switch (this) {
      case Difficulty.easy:
        return 'Relaxed ratings. Easier to get an A.';
      case Difficulty.normal:
        return 'Standard ratings.';
      case Difficulty.hard:
        return 'Strict ratings. Only near-perfect runs get an A+.';
    }
  }

  // The lowest percentage of the best possible score
  // needed for each rating, from A+ down to D.
  // Anything below the last one is an F.
  List<double> get ratingThresholds {
    switch (this) {
      case Difficulty.easy:
        return [85, 75, 60, 45, 30];
      case Difficulty.normal:
        return [92, 85, 70, 55, 40];
      case Difficulty.hard:
        return [97, 92, 80, 65, 50];
    }
  }

  String ratingFor(double percent) {
    const ratings = ['A+', 'A', 'B', 'C', 'D'];

    for (int i = 0; i < ratings.length; i++) {
      if (percent >= ratingThresholds[i]) {
        return ratings[i];
      }
    }

    return 'F';
  }
}