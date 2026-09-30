// The phases of a level, in the order they are played.
enum GamePhase {
  practice,
  listen,
  play,
  complete,
}

extension GamePhaseText on GamePhase {
  String get title {
    switch (this) {
      case GamePhase.practice:
        return 'PRACTICE';
      case GamePhase.listen:
        return 'LISTEN';
      case GamePhase.play:
        return 'PLAY';
      case GamePhase.complete:
        return 'LEVEL COMPLETE';
    }
  }

  String get description {
    switch (this) {
      case GamePhase.practice:
        return 'Tap the keys to move the worm onto each note.';
      case GamePhase.listen:
        return 'Listen to each note as it passes the worm.';
      case GamePhase.play:
        return 'Play back the tune you just heard.';
      case GamePhase.complete:
        return 'Nice work! You finished the level.';
    }
  }
}