import 'package:flame/components.dart';
import 'package:wormsounds/game/worm_sounds_game.dart';
import 'shortnote.dart';
import 'package:wormsounds/game/note.dart';
import 'package:wormsounds/game/listen.dart';
import 'package:wormsounds/game/testnote.dart';
import 'package:wormsounds/game/play.dart';
import 'package:wormsounds/game/phase.dart';
import 'package:wormsounds/game/phasemarker.dart';
import '../constants/game_constants.dart';

// Something that happens [time] seconds into a phase.
class LevelEvent {
  const LevelEvent(this.time, this.action);

  final double time;
  final void Function() action;
}

class NoteManager extends Component
    with HasGameReference<WormSoundsGame> {

  double noteSpawnTimer = 0;

  // Intro phase: explains the keys and waits for the
  // player to try moving the worm.
  double introTrack = 0;
  bool introActive = true;
  int introStep = 0;
  double introFinishedAt = 0;

  // Learning phase: introduces F, low B and high B one
  // at a time. Runs through learningEvents in order.
  double learningTrack = 0;
  bool learningActive = false;
  int learningStep = 0;

  late final List<LevelEvent> learningEvents = buildLearningEvents();

  // When (in learningTrack time) the practice phase starts.
  // Worked out in buildLearningEvents().
  double practiceStartTime = double.infinity;

  // Notes are sent from x = 500 (see spawnNote) at 200
  // pixels per second, and are 1.5 seconds apart.
  static const double noteSpawnX = 500;
  static const double noteSpeed = 200;
  static const double noteGap = 1.5;

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

  double noteHeight = 0;
  String noteLane = 'B';
  bool spawnie = false;

  // Extra break before the listen and play phases.
  static const double phaseBreak = GameConstants.phaseBreakDuration;

  // Sets which worm height the next note goes on, and
  // centres the note on that line/space.
  // Root = B, middle = F, octave = b.
  void setNoteLane(String note) {
    noteLane = note;
    noteHeight = game.noteHeightFor(note) - (game.noteSpriteHeight / 2);
  }

  // Short notes keep the shape of their sprite (72 x 48).
  double get shortNoteLength =>
      game.noteSpriteHeight * (ShortNote.spriteArea.x / ShortNote.spriteArea.y);

  // Seconds for a note to reach the worm and fully pass it.
  double get notePassTime =>
      (noteSpawnX - game.wormX + GameConstants.longNoteLength) / noteSpeed;

  // The learning phase, step by step. Each new note gets its
  // text first, then (after some reading time) is sent towards
  // the worm a couple of times. The next note's text only
  // appears once the last note has passed the worm.
  List<LevelEvent> buildLearningEvents() {
    final events = <LevelEvent>[];
    double time = 0;

    // F first, then low B, then high B.
    for (final note in ['F', 'B', 'b']) {
      events.add(
        LevelEvent(time, () {
          game.showMessage(
            PhaseMessages.learning[note]!,
            phase: GamePhase.learning,
          );
        }),
      );

      time += GameConstants.learningReadTime;

      for (int i = 0; i < GameConstants.learningNotesEach; i++) {
        events.add(
          LevelEvent(time, () {
            setNoteLane(note);
            spawnLearningNote();
          }),
        );

        time += noteGap;
      }

      // Wait for the last note to pass the worm.
      time += notePassTime - noteGap + 0.4;
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

  @override
  void update(double dt) {
    noteSpawnTimer += dt;

    if (introActive == true) {
      introTrack += dt;
    }

    if (learningActive == true) {
      learningTrack += dt;
    }

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

    // Learning: run each learning step once its time comes.

    while (learningActive == true &&
        learningStep < learningEvents.length &&
        learningTrack >= learningEvents[learningStep].time) {
      learningEvents[learningStep].action();
      learningStep++;
    }

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

  void spawnShortNote() {
    final shortNote = ShortNote(
      Vector2(500, noteHeight),
      Vector2(shortNoteLength, game.noteSpriteHeight),
      isSharpNote: false,
      lane: noteLane,
    );
    game.add(shortNote);
  }

  void spawnNote() {
    final note = Note(
      Vector2(500, noteHeight),
      Vector2(GameConstants.longNoteLength, game.noteSpriteHeight),
      isSharpNote: false,
      lane: noteLane,
    );
    game.add(note);
  }

  // Learning phase notes play like normal notes but
  // don't count towards the score.
  void spawnLearningNote() {
    final note = Note(
      Vector2(500, noteHeight),
      Vector2(GameConstants.longNoteLength, game.noteSpriteHeight),
      isSharpNote: false,
      lane: noteLane,
      isScored: false,
    );
    game.add(note);
  }

  void spawnTeach() {
    final testnote = TestNote(
      Vector2(500, noteHeight),
      Vector2(GameConstants.longNoteLength, game.noteSpriteHeight),
      isTesting: false,
      lane: noteLane,
    );
    game.add(testnote);
  }

  void spawnTest() {
    final testnote = TestNote(
      Vector2(500, noteHeight),
      Vector2(GameConstants.longNoteLength, game.noteSpriteHeight),
      isTesting: true,
      lane: noteLane,
    );
    game.add(testnote);
  }

  void spawnListen() {
    final listen = Listen(
      Vector2(500, game.staffTopY - (game.noteSpriteHeight / 2)),
      Vector2(40, game.staffHeight + game.noteSpriteHeight),
    );
    game.add(listen);
  }

  void spawnPlay() {
    final play = Play(
      Vector2(500, game.staffTopY - (game.noteSpriteHeight / 2)),
      Vector2(40, game.staffHeight + game.noteSpriteHeight),
    );
    game.add(play);
  }

  // Invisible marker that moves with the notes and changes the
  // phase text when it reaches the worm. Markers placed after a
  // note sit at that note's back edge, so the text only changes
  // once the note has fully passed the worm.
  void spawnPhaseMarker(GamePhase phase, {bool isUpNext = false, bool afterNote = false}) {
    final marker = PhaseMarker(
      Vector2(afterNote ? 500 + GameConstants.longNoteLength : 500, 0),
      phase: phase,
      isUpNext: isUpNext,
    );
    game.add(marker);
  }
}