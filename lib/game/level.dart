import 'package:wormsounds/game/notemanager.dart';

import 'endless.dart';
import 'level1.dart';
import 'level2.dart';
import 'level3.dart';

// The levels the player can pick
// from the title screen.
enum GameLevel {
  one,
  two,
  three,
  endless,
}

extension GameLevelInfo on GameLevel {
  int get number => index + 1;

  String get label {
    if (this == GameLevel.endless) {
      return 'ENDLESS';
    }

    return 'LEVEL $number';
  }

  // Shown under the level selector
  // on the title screen.
  String get description {
    switch (this) {
      case GameLevel.one:
        return 'Learn F, low B and high B.';

      case GameLevel.two:
        return 'Learning the 2nd and 3rd Interval';

      case GameLevel.three:
        return 'Learning an arpeggiated major 7th';

      case GameLevel.endless:
        return 'Random note sequences that alternate between '
            'LISTEN and PLAY. Keep going and build the '
            'highest score you can.';
    }
  }

  // Makes the note manager that controls
  // the selected level.
  NoteManager createNoteManager() {
    switch (this) {
      case GameLevel.one:
        return Level1NoteManager();

      case GameLevel.two:
        return Level2NoteManager();

      case GameLevel.three:
        return Level3NoteManager();

      case GameLevel.endless:
        return EndlessNoteManager();
    }
  }

  // Each normal level and Endless Mode
  // gets its own locally stored high score.
  String get highScoreKey {
    switch (this) {
      case GameLevel.one:
      // Keep the original key so existing
      // Level 1 scores aren't lost.
        return 'highScore';

      case GameLevel.two:
        return 'highScore_level2';

      case GameLevel.three:
        return 'highScore_level3';

      case GameLevel.endless:
        return 'highScore_endless';
    }
  }
}