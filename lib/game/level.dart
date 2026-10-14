import 'package:wormsounds/game/notemanager.dart';
import 'package:wormsounds/game/level1.dart';
import 'package:wormsounds/game/level2.dart';
import 'package:wormsounds/game/level3.dart';

// The levels the player can pick on the title screen.
// Each level's notes are in its own file (level1.dart,
// level2.dart, level3.dart).
enum GameLevel {
  one,
  two,
  three,
}

extension GameLevelInfo on GameLevel {
  int get number => index + 1;

  String get label => 'LEVEL $number';

  // Shown under the level selector on the title screen.
  String get description {
    switch (this) {
      case GameLevel.one:
        return 'Learn F, low B and high B.';
      case GameLevel.two:
        return 'Add description of level here when logic is added';
      case GameLevel.three:
        return 'Add description of level here when logic is added';
    }
  }

  // Makes the note manager that sends this level's notes.
  NoteManager createNoteManager() {
    switch (this) {
      case GameLevel.one:
        return Level1NoteManager();
      case GameLevel.two:
        return Level2NoteManager();
      case GameLevel.three:
        return Level3NoteManager();
    }
  }

  // Each level has its own high score. Level 1 keeps the
  // original name so an existing high score isn't lost.
  String get highScoreKey =>
      this == GameLevel.one ? 'highScore' : 'highScore_level$number';
}