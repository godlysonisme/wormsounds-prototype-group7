import 'package:wormsounds/game/notemanager.dart';
import 'package:wormsounds/game/phase.dart';
import '../constants/game_constants.dart';

// LEVEL 1: teaches F, low B and high B.
//
// Everything that happens in this level is mapped out here, in
// order: the intro, the learning phase, then the practice,
// listen and play stages. The spawn functions it uses
// (setNoteLane, spawnNote, spawnPhaseMarker...) are in
// notemanager.dart.
class Level1NoteManager extends NoteManager {

  // Extra break before the listen and play phases.
  static const double phaseBreak = GameConstants.phaseBreakDuration;

  // Intro: explains the keys and waits for the player to
  // try moving the worm.
  double introTrack = 0;
  bool introActive = true;
  int introStep = 0;
  double introFinishedAt = 0;

  // Learning: introduces each new note. Times in
  // updateLearning are seconds since learning started.
  double learningTrack = 0;
  bool learningActive = false;

  // When (in learningTrack time) the practice phase starts.
  // 5 seconds after "UP NEXT: PRACTICE" is shown.
  static const double practiceStartTime = 33.5;

  double stage1Track = 0;
  bool stage1Active = false;

  double stage2Track = 0;
  bool stage2Active = false;

  double stage3Track = 0;
  bool stage3Active = false;

  double stage4Track = 0;
  bool stage4Active = false;

  double stage5Track = 0;
  bool stage5Active = false;

  double drumTime = 2;

  double noteSpawnTimer = 0;
  bool spawnie = false;

  // Each block in updateLearning runs once. once('name') is
  // true the first time it is called with that name only.
  final Set<String> _done = {};
  bool once(String name) => _done.add(name);

  // The text shown as each new note is introduced.
  static const PhaseMessage learnF = PhaseMessage(
    'LEARNING: F',
    'This oncoming note is F, on the middle line of the staff. '
        'Press the F key to move the worm to its height and catch it!',
  );

  static const PhaseMessage learnLowB = PhaseMessage(
    'LEARNING: LOW B',
    'Next is low B, on the bottom line. It is the lowest note in this '
        'level. Press the B key to drop the worm down and catch it!',
  );

  static const PhaseMessage learnHighB = PhaseMessage(
    'LEARNING: HIGH B',
    'Last one: high B, in the top space. It sounds like low B, just one '
        'octave higher. Press the b key to fly up and catch it!',
  );

  // Level 1's own text, naming the notes it teaches.
  @override
  String? descriptionFor(GamePhase phase, {required bool isUpNext}) {
    if (phase == GamePhase.practice && isUpNext) {
      return 'Time to practise F, low B and high B together! Tip: hold '
          'the vibrato bar above the keys while you catch a note to add vibrato.';
    }

    if (phase == GamePhase.complete) {
      return "Great work! You learned F, low B and high B. "
          "Let's see how you did...";
    }

    return null;
  }

  @override
  void update(double dt) {
    noteSpawnTimer += dt;

    updateIntro(dt);
    updateLearning(dt);
    updateStages(dt);
  }

  // ------------------------------------------------------------
  // INTRO
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
  // Each new note: its text first, then 4.5 seconds later it is
  // sent towards the worm, twice, 1.5 seconds apart (learning
  // notes aren't scored). Each note takes 9.5 seconds in total,
  // so the next note's text only appears once the last note
  // has fully passed the worm.
  // ------------------------------------------------------------

  void updateLearning(double dt) {
    if (learningActive == false) return;

    learningTrack += dt;

    // F

    if (learningTrack >= 0 && once('F text')) {
      game.showMessage(learnF, phase: GamePhase.learning);
    }

    if (learningTrack >= 4.5 && once('F note 1')) {
      setNoteLane('F');
      spawnLearningNote();
    }

    if (learningTrack >= 6 && once('F note 2')) {
      setNoteLane('F');
      spawnLearningNote();
    }

    // Low B

    if (learningTrack >= 9.5 && once('low B text')) {
      game.showMessage(learnLowB, phase: GamePhase.learning);
    }

    if (learningTrack >= 14 && once('low B note 1')) {
      setNoteLane('B');
      spawnLearningNote();
    }

    if (learningTrack >= 15.5 && once('low B note 2')) {
      setNoteLane('B');
      spawnLearningNote();
    }

    // High B

    if (learningTrack >= 19 && once('high B text')) {
      game.showMessage(learnHighB, phase: GamePhase.learning);
    }

    if (learningTrack >= 23.5 && once('high B note 1')) {
      setNoteLane('b');
      spawnLearningNote();
    }

    if (learningTrack >= 25 && once('high B note 2')) {
      setNoteLane('b');
      spawnLearningNote();
    }

    // Get ready for the practice phase, which starts at
    // practiceStartTime (see stage 1 below).

    if (learningTrack >= 28.5 && once('up next practice')) {
      game.showPhase(GamePhase.practice, isUpNext: true);
    }
  }

  // ------------------------------------------------------------
  // PRACTICE (stages 1 to 3), LISTEN (stage 4), PLAY (stage 5)
  // Stage 1 starts once learningTrack reaches practiceStartTime.
  // ------------------------------------------------------------

  void updateStages(double dt) {


    if (stage1Active == true) {
      stage1Track += dt;
    }

    if (stage2Active == true) {
      stage2Track += dt;
    }

    if (stage3Active == true) {
      stage3Track += dt;
    }

    if (stage4Active == true) {
      stage4Track += dt;
    }

    if (stage5Active == true) {
      stage5Track += dt;
    }

    // Practice phase (stages 1 to 3)
    // Stage 1: Root and Octave

    if (stage1Active == true) {
      drumTime += dt;
      if (drumTime > 2 && drumTime < 2.1) {
        spawnDrum();
        drumTime = 0;
      }
    }

    if (learningTrack >= practiceStartTime && spawnie == false && stage1Active == false) {
      learningActive = false;
      stage1Active = true;
      spawnPhaseMarker(GamePhase.practice);
      setNoteLane('B');
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage1Track >= 2 && spawnie == true && stage1Track <= 2.2) {
      setNoteLane('b');
      spawnShortNote();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage1Track >= 4 && spawnie == false && stage1Track <= 4.1) {
      setNoteLane('b');
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage1Track >= 6 && spawnie == true && stage1Track <= 6.5) {
      setNoteLane('B');
      spawnShortNote();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    // Stage 2: Root and Middle

    if (stage1Track >= 8 && spawnie == false && stage1Track <= 8.1) {
      stage2Active = true;
      setNoteLane('B');
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage2Track >= 1.0 && spawnie == true && stage2Track <= 1.1) {
      setNoteLane('F');
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage2Track >= 3 && spawnie == false && stage2Track <= 3.1) {
      setNoteLane('F');
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage2Track >= 4.0 && spawnie == true && stage2Track <= 4.1) {
      setNoteLane('B');
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    // Stage 3: Middle and Octave

    if (stage2Track >= 6.0 && spawnie == false && stage2Track <= 6.1) {
      stage3Active = true;
      setNoteLane('F');
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage3Track >= 2.0 && spawnie == true && stage3Track <= 2.1) {
      setNoteLane('b');
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage3Track >= 3 && spawnie == false && stage3Track <= 3.1) {
      setNoteLane('b');
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage3Track >= 4 && spawnie == true && stage3Track <= 4.1) {
      setNoteLane('F');
      spawnNote();
      spawnPhaseMarker(GamePhase.listen, isUpNext: true, afterNote: true);
      noteSpawnTimer += 1;
      spawnie = false;
    }

    // Stage 4: Trial Teach (Listen phase)

    if (stage3Track >= 7 + phaseBreak && spawnie == false && stage3Track <= 7.1 + phaseBreak) {
      stage4Active = true;
      spawnPhaseMarker(GamePhase.listen);
      spawnListen();
      setNoteLane('B');
      spawnTeach();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage4Track >= 2 && spawnie == true && stage4Track <= 2.1) {
      spawnListen();
      setNoteLane('b');
      spawnTeach();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage4Track >= 4 && spawnie == false && stage4Track <= 4.1) {
      spawnListen();
      setNoteLane('F');
      spawnTeach();
      spawnPhaseMarker(GamePhase.play, isUpNext: true, afterNote: true);
      noteSpawnTimer += 1;
      spawnie = true;
    }

    // Stage 5: Test (Play phase)

    if (stage4Track >= 6 + phaseBreak && spawnie == true && stage4Track <= 6.1 + phaseBreak) {
      stage5Active = true;
      spawnPhaseMarker(GamePhase.play);
      spawnPlay();
      setNoteLane('B');
      spawnTest();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage5Track >= 8 && spawnie == false && stage5Track <= 8.1) {
      spawnPlay();
      setNoteLane('b');
      spawnTest();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage5Track >= 10 && spawnie == true && stage5Track <= 10.1) {
      spawnPlay();
      setNoteLane('F');
      spawnTest();
      spawnPhaseMarker(GamePhase.complete, afterNote: true);
      noteSpawnTimer += 1;
      spawnie = false;
    }
  }
}
