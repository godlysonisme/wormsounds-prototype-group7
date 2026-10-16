import 'package:wormsounds/game/notemanager.dart';
import 'package:wormsounds/game/phase.dart';
import '../constants/game_constants.dart';

class Level2NoteManager extends NoteManager {
  // Extra break before the listen and play phases.
  static const double phaseBreak =
      GameConstants.phaseBreakDuration;

  // Level 2 skips the tutorial and starts
  // immediately with its learning phase.
  double introTrack = 0;
  bool introActive = false;
  int introStep = 0;
  double introFinishedAt = 0;

  // Learning starts immediately.
  double learningTrack = 0;
  bool learningActive = true;

  // When the practice phase starts.
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

  // Makes sure each timed event only runs once.
  final Set<String> _done = {};

  bool once(String name) =>
      _done.add(name);

  // ------------------------------------------------------------
  // LEARNING TEXT
  // ------------------------------------------------------------

  static const PhaseMessage learnG =
  PhaseMessage(
    'LEARNING: G',
    'This next note is G, try to catch it! '
        'G is the first note in the G scale',
  );

  static const PhaseMessage learnA =
  PhaseMessage(
    'LEARNING: A',
    'The upcoming note, A is the second note in the scale. '
        'Press the A key to catch it!',
  );

  static const PhaseMessage learnB =
  PhaseMessage(
    'LEARNING: B',
    "Next one: a familiar note, B, take a look, it's the third. "
        'Press the B key to fly up and catch it!',
  );

  static const PhaseMessage learnC =
  PhaseMessage(
    'LEARNING: C',
    'Last one: C, this is the perfect fourth of the scale '
        'when paired with the root it sounds a bit medieval',
  );

  // ------------------------------------------------------------
  // PHASE TEXT
  // ------------------------------------------------------------

  @override
  String? descriptionFor(
      GamePhase phase, {
        required bool isUpNext,
      }) {
    if (phase == GamePhase.practice &&
        isUpNext) {
      return 'Time to practise these notes together! '
          'The concept of the scale is almost yours!.';
    }

    if (phase == GamePhase.complete) {
      return "Great work! You've learned the second and third! "
          "Let's see how you did...";
    }

    return null;
  }

  // ------------------------------------------------------------
  // UPDATE
  // ------------------------------------------------------------

  @override
  void update(double dt) {
    noteSpawnTimer += dt;

    updateIntro(dt);
    updateLearning(dt);
    updateStages(dt);
  }

  // ------------------------------------------------------------
  // INTRO
  // Level 2 skips this because introActive starts false.
  // ------------------------------------------------------------

  void updateIntro(double dt) {
    if (introActive == false) {
      return;
    }

    introTrack += dt;

    if (introStep == 0 &&
        ((introTrack >=
            GameConstants.introMinimumTime &&
            game.wormMoveCount >=
                GameConstants.introMovesNeeded) ||
            introTrack >=
                GameConstants.introMaximumTime)) {
      game.showMessage(
        PhaseMessages.howToPlay,
      );

      introFinishedAt =
          introTrack;

      introStep = 1;
    }

    if (introStep == 1 &&
        introTrack >=
            introFinishedAt +
                GameConstants.howToPlayTime) {
      introActive = false;
      learningActive = true;
      introStep = 2;
    }
  }

  // ------------------------------------------------------------
  // LEARNING
  // ------------------------------------------------------------

  void updateLearning(double dt) {
    if (learningActive == false) {
      return;
    }

    learningTrack += dt;

    // G

    if (learningTrack >= 0 &&
        once('G text')) {
      game.showMessage(
        learnG,
        phase: GamePhase.learning,
      );
    }

    if (learningTrack >= 2 &&
        once('G note 1')) {
      setNoteLane('G');
      spawnLearningNote();
    }

    if (learningTrack >= 4 &&
        once('G note 2')) {
      setNoteLane('G');
      spawnLearningNote();
    }

    // A

    if (learningTrack >= 6 &&
        once('A text')) {
      game.showMessage(
        learnA,
        phase: GamePhase.learning,
      );
    }

    if (learningTrack >= 9 &&
        once('A note 1')) {
      setNoteLane('A');
      spawnLearningNote();
    }

    if (learningTrack >= 11 &&
        once('A note 2')) {
      setNoteLane('A');
      spawnLearningNote();
    }

    // B

    if (learningTrack >= 13 &&
        once('B text')) {
      game.showMessage(
        learnB,
        phase: GamePhase.learning,
      );
    }

    if (learningTrack >= 16 &&
        once('B note 1')) {
      setNoteLane('b');
      spawnLearningNote();
    }

    if (learningTrack >= 18 &&
        once('B note 2')) {
      setNoteLane('b');
      spawnLearningNote();
    }

    if (learningTrack >= 20 &&
        once('up next practice')) {
      game.showPhase(
        GamePhase.practice,
        isUpNext: true,
      );
    }
  }

  // ------------------------------------------------------------
  // PRACTICE / LISTEN / PLAY
  // ------------------------------------------------------------

  void updateStages(double dt) {
    if (stage1Active) {
      stage1Track += dt;
    }

    if (stage2Active) {
      stage2Track += dt;
    }

    if (stage3Active) {
      stage3Track += dt;
    }

    if (stage4Active) {
      stage4Track += dt;
    }

    if (stage5Active) {
      stage5Track += dt;
    }

    // ----------------------------------------------------------
    // PRACTICE
    // ----------------------------------------------------------

    if (stage1Active) {
      drumTime += dt;

      if (drumTime > 2 &&
          drumTime < 2.1) {
        spawnDrum();
        drumTime = 0;
      }
    }

    // Stage 1

    if (learningTrack >=
        practiceStartTime &&
        spawnie == false &&
        stage1Active == false) {
      learningActive = false;
      stage1Active = true;

      spawnPhaseMarker(
        GamePhase.practice,
      );

      setNoteLane('G');
      spawnNote();

      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage1Track >= 2 &&
        spawnie == true &&
        stage1Track <= 2.2) {
      setNoteLane('A');
      spawnShortNote();

      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage1Track >= 4 &&
        spawnie == false &&
        stage1Track <= 4.1) {
      setNoteLane('G');
      spawnNote();

      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage1Track >= 6 &&
        spawnie == true &&
        stage1Track <= 6.5) {
      setNoteLane('A');
      spawnShortNote();

      noteSpawnTimer += 1;
      spawnie = false;
    }

    // Stage 2

    if (stage1Track >= 8 &&
        spawnie == false &&
        stage1Track <= 8.1) {
      stage2Active = true;

      setNoteLane('G');
      spawnNote();

      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage2Track >= 1 &&
        spawnie == true &&
        stage2Track <= 1.1) {
      setNoteLane('b');
      spawnNote();

      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage2Track >= 3 &&
        spawnie == false &&
        stage2Track <= 3.1) {
      setNoteLane('G');
      spawnNote();

      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage2Track >= 4 &&
        spawnie == true &&
        stage2Track <= 4.1) {
      setNoteLane('b');
      spawnNote();

      noteSpawnTimer += 1;
      spawnie = false;
    }

    // Stage 3

    if (stage2Track >= 6 &&
        spawnie == false &&
        stage2Track <= 6.1) {
      stage3Active = true;

      setNoteLane('b');
      spawnNote();

      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage3Track >= 2 &&
        spawnie == true &&
        stage3Track <= 2.1) {
      setNoteLane('A');
      spawnNote();

      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage3Track >= 3 &&
        spawnie == false &&
        stage3Track <= 3.1) {
      setNoteLane('b');
      spawnNote();

      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage3Track >= 4 &&
        spawnie == true &&
        stage3Track <= 4.1) {
      setNoteLane('A');
      spawnNote();

      spawnPhaseMarker(
        GamePhase.listen,
        isUpNext: true,
        afterNote: true,
      );

      noteSpawnTimer += 1;
      spawnie = false;
    }

    // ----------------------------------------------------------
    // LISTEN
    // ----------------------------------------------------------

    if (stage3Track >= 7 &&
        spawnie == false &&
        stage3Track <= 7.1) {
      stage4Active = true;

      spawnPhaseMarker(
        GamePhase.listen,
      );

      spawnListen();

      setNoteLane('G');
      spawnTeach();

      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage4Track >= 1 &&
        spawnie == true &&
        stage4Track <= 1.1) {
      spawnListen();

      setNoteLane('A');
      spawnTeach();

      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage4Track >= 2 &&
        spawnie == false &&
        stage4Track <= 2.1) {
      spawnListen();

      setNoteLane('b');
      spawnTeach();

      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage4Track >= 3 &&
        spawnie == true &&
        stage4Track <= 3.1) {
      spawnListen();

      setNoteLane('G');
      spawnTeach();

      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage4Track >= 4 &&
        spawnie == false &&
        stage4Track <= 4.1) {
      spawnListen();

      setNoteLane('A');
      spawnTeach();

      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage4Track >= 5 &&
        spawnie == true &&
        stage4Track <= 5.1) {
      spawnListen();

      setNoteLane('b');
      spawnTeach();

      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage4Track >= 5.5 &&
        spawnie == false &&
        stage4Track <= 5.6) {
      spawnListen();

      setNoteLane('b');
      spawnTeach();

      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage4Track >= 7 &&
        spawnie == true &&
        stage4Track <= 7.1) {
      spawnListen();

      setNoteLane('G');
      spawnTeach();

      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage4Track >= 8 &&
        spawnie == false &&
        stage4Track <= 8.1) {
      spawnListen();

      setNoteLane('A');
      spawnTeach();

      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage4Track >= 9 &&
        spawnie == true &&
        stage4Track <= 9.1) {
      spawnListen();

      setNoteLane('b');
      spawnTeach();

      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage4Track >= 10 &&
        spawnie == false &&
        stage4Track <= 10.1) {
      spawnListen();

      setNoteLane('A');
      spawnTeach();

      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage4Track >= 11 &&
        spawnie == true &&
        stage4Track <= 11.1) {
      spawnListen();

      setNoteLane('G');
      spawnTeach();

      spawnPhaseMarker(
        GamePhase.play,
        isUpNext: true,
        afterNote: true,
      );

      noteSpawnTimer += 1;
      spawnie = false;
    }

    // ----------------------------------------------------------
    // PLAY
    // ----------------------------------------------------------

    if (stage4Track >= 14 &&
        spawnie == false &&
        stage4Track <= 14.1) {
      stage5Active = true;

      spawnPhaseMarker(
        GamePhase.play,
      );

      spawnPlay();

      setNoteLane('G');
      spawnTest();

      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage5Track >= 1 &&
        spawnie == true &&
        stage5Track <= 1.1) {
      spawnPlay();

      setNoteLane('A');
      spawnTest();

      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage5Track >= 2 &&
        spawnie == false &&
        stage5Track <= 2.1) {
      spawnPlay();

      setNoteLane('b');
      spawnTest();

      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage5Track >= 3 &&
        spawnie == true &&
        stage5Track <= 3.1) {
      spawnPlay();

      setNoteLane('G');
      spawnTest();

      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage5Track >= 4 &&
        spawnie == false &&
        stage5Track <= 4.1) {
      spawnPlay();

      setNoteLane('A');
      spawnTest();

      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage5Track >= 5 &&
        spawnie == true &&
        stage5Track <= 5.1) {
      spawnPlay();

      setNoteLane('b');
      spawnTest();

      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage5Track >= 5.5 &&
        spawnie == false &&
        stage5Track <= 5.6) {
      spawnPlay();

      setNoteLane('b');
      spawnTest();

      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage5Track >= 7 &&
        spawnie == true &&
        stage5Track <= 7.1) {
      spawnPlay();

      setNoteLane('G');
      spawnTest();

      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage5Track >= 8 &&
        spawnie == false &&
        stage5Track <= 8.1) {
      spawnPlay();

      setNoteLane('A');
      spawnTest();

      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage5Track >= 9 &&
        spawnie == true &&
        stage5Track <= 9.1) {
      spawnPlay();

      setNoteLane('b');
      spawnTest();

      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage5Track >= 10 &&
        spawnie == false &&
        stage5Track <= 10.1) {
      spawnPlay();

      setNoteLane('A');
      spawnTest();

      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage5Track >= 11 &&
        spawnie == true &&
        stage5Track <= 11.1) {
      spawnPlay();

      setNoteLane('G');
      spawnTest();

      spawnPhaseMarker(
        GamePhase.complete,
        afterNote: true,
      );

      noteSpawnTimer += 1;
      spawnie = false;
    }
  }
}