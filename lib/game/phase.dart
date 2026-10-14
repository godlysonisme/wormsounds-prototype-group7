// The phases of a level, in the order they are played.
enum GamePhase {
  intro,
  learning,
  practice,
  listen,
  play,
  complete,
}

extension GamePhaseText on GamePhase {
  String get title {
    switch (this) {
      case GamePhase.intro:
        return 'WELCOME TO WORM SOUNDS!';
      case GamePhase.learning:
        return 'LEARNING';
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

  // Shown while the phase is happening. A level can
  // replace any of these with its own text (see
  // descriptionFor in level1.dart).
  String get description {
    switch (this) {
      case GamePhase.intro:
        return 'Each piano key at the bottom of the screen moves the worm '
            'to a different height on the staff. Try tapping a few keys now!';
      case GamePhase.learning:
        return 'Learn each new note by moving the worm to its height '
            'and catching it.';
      case GamePhase.practice:
        return "Move the worm to each note's height before it arrives. "
            'Short notes pass by quickly, so get there early!';
      case GamePhase.listen:
        return 'Just listen! Each note plays as it reaches the worm. '
            'Try to remember which notes you hear, and in what order.';
      case GamePhase.play:
        return 'Catch each note to play the tune back, in the same '
            'order you heard the notes in the listen phase.';
      case GamePhase.complete:
        return "Great work! Let's see how you did...";
    }
  }

  // Shown during the break before the phase starts
  // ("UP NEXT: ..."), explaining what is about to happen.
  String get upNextDescription {
    switch (this) {
      case GamePhase.practice:
        return 'Time to practise the notes you just learned together! Tip: hold '
            'the vibrato bar above the keys while you catch a note to add vibrato.';
      case GamePhase.listen:
        return 'A short tune made from your three notes will play next. '
            "You don't need to catch these notes, just listen and remember the order.";
      case GamePhase.play:
        return 'Your turn! Play back the tune you just heard by moving '
            'the worm to catch each note in the same order.';
      case GamePhase.intro:
      case GamePhase.learning:
      case GamePhase.complete:
        return description;
    }
  }
}

// A title and description for the text box above the staff.
class PhaseMessage {
  const PhaseMessage(this.title, this.description);

  final String title;
  final String description;
}

class PhaseMessages {
  // Second part of the intro, shown once the player has
  // tried moving the worm.
  static const PhaseMessage howToPlay = PhaseMessage(
    'HOW TO PLAY',
    'Notes will fly in from the right. Move the worm to the same height '
        'as a note before it arrives to catch it and hear its sound.',
  );

  // Shown as each new note is introduced in level 1's
  // learning phase. Keys match the piano keys:
  // 'B' = low B, 'b' = high B.
  static const Map<String, PhaseMessage> learning = {
    'F': PhaseMessage(
      'LEARNING: F',
      'This oncoming note is F, on the middle line of the staff. '
          'Press the F key to move the worm to its height and catch it!',
    ),
    'B': PhaseMessage(
      'LEARNING: LOW B',
      'Next is low B, on the bottom line. It is the lowest note in this '
          'level. Press the B key to drop the worm down and catch it!',
    ),
    'b': PhaseMessage(
      'LEARNING: HIGH B',
      'Last one: high B, in the top space. It sounds like low B, just one '
          'octave higher. Press the b key to fly up and catch it!',
    ),
  };
}