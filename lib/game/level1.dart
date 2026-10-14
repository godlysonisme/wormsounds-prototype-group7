import 'package:wormsounds/game/notemanager.dart';
import 'package:wormsounds/game/phase.dart';
import '../constants/game_constants.dart';

// LEVEL 1: teaches F, low B and high B.

// Learning: each new note is introduced with its own text.
// Practice (stages 1 to 3), Listen (stage 4) and Play
// (stage 5) are timed in updateStages below.
class Level1NoteManager extends NoteManager {

  // When (in timelineTrack time) the practice phase starts.
  // Worked out in buildTimeline().
  double practiceStartTime = double.infinity;

  // Extra break before the listen and play phases.
  static const double phaseBreak = GameConstants.phaseBreakDuration;

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

  // The learning phase: F first, then low B, then high B.
  // Then "UP NEXT: PRACTICE" is shown before stage 1 starts.
  @override
  List<LevelEvent> buildTimeline() {
    final events = <LevelEvent>[];
    double time = 0;

    for (final note in ['F', 'B', 'b']) {
      time = addLearningNote(
        events,
        time,
        note,
        PhaseMessages.learning[note]!,
      );
    }

    // Then get ready for the practice phase.
    events.add(
      LevelEvent(time, () {
        game.showPhase(
          GamePhase.practice,
          isUpNext: true,
        );
      }),
    );

    practiceStartTime = time + GameConstants.practiceReadTime;

    return events;
  }

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

    if (timelineTrack >= practiceStartTime && spawnie == false && stage1Active == false) {
      timelineActive = false;
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

    if (stage2Track >= 1.5 && spawnie == true && stage2Track <= 1.6) {
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

    if (stage2Track >= 4.5 && spawnie == true && stage2Track <= 4.6) {
      setNoteLane('B');
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    // Stage 3: Middle and Octave

    if (stage2Track >= 6.5 && spawnie == false && stage2Track <= 6.6) {
      stage3Active = true;
      setNoteLane('F');
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage3Track >= 1.5 && spawnie == true && stage3Track <= 1.6) {
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

    if (stage3Track >= 4.5 && spawnie == true && stage3Track <= 4.6) {
      setNoteLane('F');
      spawnNote();
      spawnPhaseMarker(GamePhase.listen, isUpNext: true, afterNote: true);
      noteSpawnTimer += 1;
      spawnie = false;
    }

    // Stage 4: Trial Teach (Listen phase)

    if (stage3Track >= 6.5 + phaseBreak && spawnie == false && stage3Track <= 6.6 + phaseBreak) {
      stage4Active = true;
      spawnPhaseMarker(GamePhase.listen);
      spawnListen();
      setNoteLane('B');
      spawnTeach();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage4Track >= 1.5 && spawnie == true && stage4Track <= 1.6) {
      spawnListen();
      setNoteLane('b');
      spawnTeach();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage4Track >= 3 && spawnie == false && stage4Track <= 3.1) {
      spawnListen();
      setNoteLane('F');
      spawnTeach();
      spawnPhaseMarker(GamePhase.play, isUpNext: true, afterNote: true);
      noteSpawnTimer += 1;
      spawnie = true;
    }

    // Stage 5: Test (Play phase)

    if (stage4Track >= 5 + phaseBreak && spawnie == true && stage4Track <= 5.1 + phaseBreak) {
      stage5Active = true;
      spawnPhaseMarker(GamePhase.play);
      spawnPlay();
      setNoteLane('B');
      spawnTest();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage5Track >= 1.5 && spawnie == false && stage5Track <= 1.6) {
      spawnPlay();
      setNoteLane('b');
      spawnTest();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage5Track >= 3 && spawnie == true && stage5Track <= 3.1) {
      spawnPlay();
      setNoteLane('F');
      spawnTest();
      spawnPhaseMarker(GamePhase.complete, afterNote: true);
      noteSpawnTimer += 1;
      spawnie = false;
    }
  }
}