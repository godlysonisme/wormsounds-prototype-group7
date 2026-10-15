import 'package:wormsounds/game/notemanager.dart';
import 'package:wormsounds/game/phase.dart';
import '../constants/game_constants.dart';

class Level3NoteManager extends NoteManager {

  // Extra break before the listen and play phases.
  static const double phaseBreak = GameConstants.phaseBreakDuration;

  // Intro: explains the keys and waits for the player to
  // try moving the worm.
  double introTrack = 0;
  bool introActive = false;
  int introStep = 0;
  double introFinishedAt = 0;

  // Learning: introduces each new note. Times in
  // updateLearning are seconds since learning started.
  double learningTrack = 0;
  bool learningActive = true;

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
  static const PhaseMessage learnC = PhaseMessage(
    'LEARNING: C',
    'The first note in this lesson is the trusty C. '
        'Here, it acts as the root in the C scale',
  );

  static const PhaseMessage learnE = PhaseMessage(
    'LEARNING: E',
    'E is the 3rd note in the C scale. '
        'E will be helping us out in this chord',
  );

  static const PhaseMessage learnG = PhaseMessage(
    'LEARNING: G',
    "Next one: G, which is the fifth of the C scale "
        'The root and fifth sound great together',
  );

  static const PhaseMessage learnB = PhaseMessage(
    'LEARNING: B',
    'Last one: b, the 7th, the final piece of the puzzle. '
        'Almost a C again but not quite',
  );

  // Level 1's own text, naming the notes it teaches.
  @override
  String? descriptionFor(GamePhase phase, {required bool isUpNext}) {
    if (phase == GamePhase.practice && isUpNext) {
      return 'Time to practise these notes together! '
          "What you've just learnt is the C major 7 chord!";
    }

    if (phase == GamePhase.complete) {
      return "Great work! You've arpeggiated the chord! "
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

    if (learningTrack >= 0 && once('C text')) {
      game.showMessage(learnC, phase: GamePhase.learning);
    }

    if (learningTrack >= 2 && once('C note 1')) {
      setNoteLane('C');
      spawnLearningNote();
    }

    if (learningTrack >= 3 && once('C note 2')) {
      setNoteLane('C');
      spawnLearningNote();
    }

    // Low B

    if (learningTrack >= 6 && once('E text')) {
      game.showMessage(learnE, phase: GamePhase.learning);
    }

    if (learningTrack >= 8 && once('E note 1')) {
      setNoteLane('E');
      spawnLearningNote();
    }

    if (learningTrack >= 9 && once('E note 2')) {
      setNoteLane('E');
      spawnLearningNote();
    }

    // High B

    if (learningTrack >= 12 && once('G text')) {
      game.showMessage(learnG, phase: GamePhase.learning);
    }

    if (learningTrack >= 14 && once('G note 1')) {
      setNoteLane('G');
      spawnLearningNote();
    }

    if (learningTrack >= 15 && once('G note 2')) {
      setNoteLane('G');
      spawnLearningNote();
    }

    // B

    if (learningTrack >= 17 && once('B text')) {
      game.showMessage(learnB, phase: GamePhase.learning);
    }

    if (learningTrack >= 19 && once('B note 1')) {
      setNoteLane('b');
      spawnLearningNote();
    }

    if (learningTrack >= 21 && once('B note 2')) {
      setNoteLane('b');
      spawnLearningNote();
    }

    // Get ready for the practice phase, which starts at
    // practiceStartTime (see stage 1 below).

    if (learningTrack >= 24 && once('up next practice')) {
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
    // Stage 1: Root and Second

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
      setNoteLane('C');
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage1Track >= 2 && spawnie == true && stage1Track <= 2.2) {
      setNoteLane('E');
      spawnShortNote();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage1Track >= 4 && spawnie == false && stage1Track <= 4.1) {
      setNoteLane('C');
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage1Track >= 6 && spawnie == true && stage1Track <= 6.5) {
      setNoteLane('G');
      spawnShortNote();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage1Track >= 8 && spawnie == false && stage1Track <= 8.1) {
      stage2Active = true;
      setNoteLane('C');
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage2Track >= 1.0 && spawnie == true && stage2Track <= 1.1) {
      setNoteLane('b');
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage2Track >= 3 && spawnie == false && stage2Track <= 3.1) {
      setNoteLane('G');
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage2Track >= 4.0 && spawnie == true && stage2Track <= 4.1) {
      setNoteLane('b');
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage2Track >= 6.0 && spawnie == false && stage2Track <= 6.1) {
      stage3Active = true;
      setNoteLane('E');
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
      setNoteLane('C');
      spawnNote();
      spawnPhaseMarker(GamePhase.listen, isUpNext: true, afterNote: true);
      noteSpawnTimer += 1;
      spawnie = true;
    }

    // Stage 4: Trial Teach (Listen phase)

    if (stage3Track >= 5 && spawnie == true && stage3Track <= 5.1) {
      stage4Active = true;
      spawnPhaseMarker(GamePhase.listen);
      spawnListen();
      setNoteLane('C');
      spawnTeach();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage4Track >= 1 && spawnie == false && stage4Track <= 1.1) {
      spawnListen();
      setNoteLane('E');
      spawnTeach();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage4Track >= 2 && spawnie == true && stage4Track <= 2.1) {
      spawnListen();
      setNoteLane('G');
      spawnTeach();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage4Track >= 3 && spawnie == false && stage4Track <= 3.1) {
      spawnListen();
      setNoteLane('b');
      spawnTeach();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage4Track >= 4 && spawnie == true && stage4Track <= 4.1) {
      spawnListen();
      setNoteLane('C');
      spawnTeach();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage4Track >= 5 && spawnie == false && stage4Track <= 5.1) {
      spawnListen();
      setNoteLane('E');
      spawnTeach();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage4Track >= 6.1 && spawnie == true && stage4Track <= 6.1) {
      spawnListen();
      setNoteLane('C');
      spawnTeach();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage4Track >= 7 && spawnie == false && stage4Track <= 7.1) {
      spawnListen();
      setNoteLane('E');
      spawnTeach();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage4Track >= 8 && spawnie == true && stage4Track <= 8.1) {
      spawnListen();
      setNoteLane('G');
      spawnTeach();
      noteSpawnTimer += 1;
      spawnie = false;
    }
    if (stage4Track >= 9 && spawnie == false && stage4Track <= 9.1) {
      spawnListen();
      setNoteLane('b');
      spawnPhaseMarker(GamePhase.play, isUpNext: true, afterNote: true);
      spawnTeach();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    // Stage 5: Test (Play phase)

    if (stage4Track >= 12 && spawnie == true && stage4Track <= 12.1) {
      stage5Active = true;
      spawnPhaseMarker(GamePhase.play);
      spawnPlay();
      setNoteLane('C');
      spawnTest();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage5Track >= 1 && spawnie == false && stage5Track <= 1.1) {
      spawnPlay();
      setNoteLane('E');
      spawnTest();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage5Track >= 2 && spawnie == true && stage5Track <= 2.1) {
      spawnPlay();
      setNoteLane('G');
      spawnTest();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage5Track >= 3 && spawnie == false && stage5Track <= 3.1) {
      spawnPlay();
      setNoteLane('b');
      spawnTest();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage5Track >= 4 && spawnie == true && stage5Track <= 4.1) {
      spawnPlay();
      setNoteLane('C');
      spawnTest();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage5Track >= 5.0 && spawnie == false && stage5Track <= 5.1) {
      spawnPlay();
      setNoteLane('E');
      spawnTest();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage5Track >= 6.0 && spawnie == true && stage5Track <= 6.1) {
      spawnPlay();
      setNoteLane('C');
      spawnTest();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage5Track >= 7 && spawnie == false && stage5Track <= 7.1) {
      spawnPlay();
      setNoteLane('E');
      spawnTest();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage5Track >= 8 && spawnie == true && stage5Track <= 8.1) {
      spawnPlay();
      setNoteLane('G');
      spawnTest();
      noteSpawnTimer += 1;
      spawnie = false;
    }
    if (stage5Track >= 9 && spawnie == false && stage5Track <= 9.1) {
      spawnPlay();
      setNoteLane('b');
      spawnTest();
      spawnPhaseMarker(GamePhase.complete, afterNote: true);
      noteSpawnTimer += 1;
      spawnie = true;
    }
  }
}
