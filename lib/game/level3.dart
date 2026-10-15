import 'package:wormsounds/game/notemanager.dart';
import 'package:wormsounds/game/phase.dart';
import '../constants/game_constants.dart';

// LEVEL 3: placeholder, no notes yet.
//
// Laid out the same way as level1.dart: the intro, then the
// learning, practice, listen and play phases, in order. It
// already goes through every phase, but no notes are sent yet.
//
// Each phase has its own clock (e.g. practiceTrack = seconds
// since the practice phase started), so adding notes to one
// phase doesn't change the times in the other phases.
//
// To add a note, add a block to the right phase, e.g.
//
//   if (practiceTrack >= 1.5 && once('practice note 2')) {
//     setNoteLane('C');
//     spawnNote();
//   }
//
// Each block needs its own name inside once(...), so it only
// runs once. Keep notes at least 1.5 seconds apart (a long note
// is 1 second long), and change the time in each phase's "END
// OF PHASE" blocks to the time of that phase's last note.
//
// Note heights: 'B' (bottom line), 'C', 'D', 'E', 'F' (middle
// line), 'G', 'A', 'b' (top space).
//
// Also update this level's description on the title screen in
// level.dart once it has notes.
class Level3NoteManager extends NoteManager {

  // Extra break before the listen and play phases.
  static const double phaseBreak = GameConstants.phaseBreakDuration;

  // Intro: explains the keys and waits for the player to
  // try moving the worm.
  double introTrack = 0;
  bool introActive = true;
  int introStep = 0;
  double introFinishedAt = 0;

  // Each phase's clock, and whether that phase is running.
  double learningTrack = 0;
  bool learningActive = false;

  double practiceTrack = 0;
  bool practiceActive = false;

  double listenTrack = 0;
  bool listenActive = false;

  double playTrack = 0;
  bool playActive = false;

  // Each block below runs once. once('name') is true the
  // first time it is called with that name only.
  final Set<String> _done = {};
  bool once(String name) => _done.add(name);

  // The text shown as each new note is introduced, e.g.
  //
  // static const PhaseMessage learnC = PhaseMessage(
  //   'LEARNING: C',
  //   'This oncoming note is C, just above the bottom line. '
  //       'Press the C key to move the worm to its height and catch it!',
  // );

  @override
  void update(double dt) {
    updateIntro(dt);
    updateLearning(dt);
    updatePractice(dt);
    updateListen(dt);
    updatePlay(dt);
  }

  // ------------------------------------------------------------
  // INTRO (the same in every level)
  // ------------------------------------------------------------

  void updateIntro(double dt) {
    if (introActive == false) return;

    introTrack += dt;

    // Intro 1: once the player has had a go at moving the
    // worm (or has waited a long time), explain how to play.

    if (introStep == 0 &&
        ((introTrack >= GameConstants.introMinimumTime &&
            game.wormMoveCount >= GameConstants.introMovesNeeded) ||
            introTrack >= GameConstants.introMaximumTime)) {
      game.showMessage(PhaseMessages.howToPlay);
      introFinishedAt = introTrack;
      introStep = 1;
    }

    // Intro 2: after "HOW TO PLAY", start the learning phase.

    if (introStep == 1 &&
        introTrack >= introFinishedAt + GameConstants.howToPlayTime) {
      introActive = false;
      learningActive = true;
      introStep = 2;
    }
  }

  // ------------------------------------------------------------
  // LEARNING
  // For each new note: its text, then 4.5 seconds later send
  // it twice, 1.5 seconds apart (learning notes aren't scored).
  // Give each new note 9.5 seconds, like level1.dart. E.g.
  //
  //   if (learningTrack >= 0 && once('C text')) {
  //     game.showMessage(learnC, phase: GamePhase.learning);
  //   }
  //
  //   if (learningTrack >= 4.5 && once('C note 1')) {
  //     setNoteLane('C');
  //     spawnLearningNote();
  //   }
  //
  //   if (learningTrack >= 6 && once('C note 2')) {
  //     setNoteLane('C');
  //     spawnLearningNote();
  //   }
  // ------------------------------------------------------------

  void updateLearning(double dt) {
    if (learningActive == false) return;

    learningTrack += dt;

    // Placeholder text until this level's new notes are added.
    // Replace this block with the blocks for each new note.

    if (learningTrack >= 0 && once('learning text')) {
      game.showPhase(GamePhase.learning);
    }

    // END OF PHASE: "UP NEXT: PRACTICE" (leave 3.5 seconds
    // after the last learning note so it has passed the worm),
    // then the practice phase starts 5 seconds later.

    if (learningTrack >= 6 && once('up next practice')) {
      game.showPhase(GamePhase.practice, isUpNext: true);
    }

    if (learningTrack >= 6 + 5) {
      learningActive = false;
      practiceActive = true;
    }
  }

  // ------------------------------------------------------------
  // PRACTICE
  // Notes to catch, e.g.
  //
  //   if (practiceTrack >= 0 && once('practice note 1')) {
  //     setNoteLane('C');
  //     spawnNote();          // or spawnShortNote();
  //   }
  // ------------------------------------------------------------

  void updatePractice(double dt) {
    if (practiceActive == false) return;

    practiceTrack += dt;

    if (practiceTrack >= 0 && once('practice text')) {
      spawnPhaseMarker(GamePhase.practice);
    }

    // Practice notes go here.

    // END OF PHASE: change 6 to the time of the last practice
    // note. "UP NEXT: LISTEN" shows once that note has passed
    // the worm, then the listen phase starts after a break.

    if (practiceTrack >= 6 && once('up next listen')) {
      spawnPhaseMarker(GamePhase.listen, isUpNext: true, afterNote: true);
    }

    if (practiceTrack >= 6 + 2 + phaseBreak) {
      practiceActive = false;
      listenActive = true;
    }
  }

  // ------------------------------------------------------------
  // LISTEN
  // The tune the player listens to (plays by itself), e.g.
  //
  //   if (listenTrack >= 0 && once('listen note 1')) {
  //     spawnListen();
  //     setNoteLane('C');
  //     spawnTeach();
  //   }
  // ------------------------------------------------------------

  void updateListen(double dt) {
    if (listenActive == false) return;

    listenTrack += dt;

    if (listenTrack >= 0 && once('listen text')) {
      spawnPhaseMarker(GamePhase.listen);
    }

    // Listen notes go here.

    // END OF PHASE: change 6 to the time of the last listen
    // note. "UP NEXT: PLAY" shows once that note has passed
    // the worm, then the play phase starts after a break.

    if (listenTrack >= 6 && once('up next play')) {
      spawnPhaseMarker(GamePhase.play, isUpNext: true, afterNote: true);
    }

    if (listenTrack >= 6 + 2 + phaseBreak) {
      listenActive = false;
      playActive = true;
    }
  }

  // ------------------------------------------------------------
  // PLAY
  // The same tune again, for the player to catch, e.g.
  //
  //   if (playTrack >= 0 && once('play note 1')) {
  //     spawnPlay();
  //     setNoteLane('C');
  //     spawnTest();
  //   }
  // ------------------------------------------------------------

  void updatePlay(double dt) {
    if (playActive == false) return;

    playTrack += dt;

    if (playTrack >= 0 && once('play text')) {
      spawnPhaseMarker(GamePhase.play);
    }

    // Play notes go here.

    // END OF PHASE: change 6 to the time of the last play
    // note. "LEVEL COMPLETE" shows once that note has passed
    // the worm, then the end level screen appears.

    if (playTrack >= 6 && once('level complete')) {
      spawnPhaseMarker(GamePhase.complete, afterNote: true);
    }
  }
}
