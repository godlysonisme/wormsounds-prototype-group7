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
import 'package:wormsounds/game/timeline.dart';

// Something that happens [time] seconds into a level's
// timeline (or into a phase, for the phase note lists in
// level2.dart and level3.dart).
class LevelEvent {
  const LevelEvent(this.time, this.action);

  final double time;
  final void Function() action;
}

// Sends the notes for a level. Each level has its own note
// manager that extends this one (see level1.dart, level2.dart
// and level3.dart).
//
// This class runs the intro, which is the same in every
// level, then the level's timeline (from buildTimeline). It
// also has the helpers for sending notes and phase markers.
abstract class NoteManager extends Component
    with HasGameReference<WormSoundsGame> {

  double noteSpawnTimer = 0;

  // Intro phase: explains the keys and waits for the
  // player to try moving the worm.
  double introTrack = 0;
  bool introActive = true;
  int introStep = 0;
  double introFinishedAt = 0;

  // Timeline: starts once the intro has finished and runs
  // through timelineEvents in order.
  double timelineTrack = 0;
  bool timelineActive = false;
  int timelineStep = 0;

  late final List<LevelEvent> timelineEvents = buildTimeline();

  // Notes are sent from x = 500 (see spawnNote) at 200
  // pixels per second, and are 1.5 seconds apart.
  static const double noteSpawnX = 500;
  static const double noteSpeed = 200;
  static const double noteGap = 1.5;

  double noteHeight = 0;
  String noteLane = 'B';
  bool spawnie = false;

  // Extra break before the listen and play phases.
  static const double phaseBreak = GameConstants.phaseBreakDuration;

  // Everything that happens after the intro, in time order.
  // Times are seconds since the intro finished.
  List<LevelEvent> buildTimeline();

  // Called every frame after the timeline. Level 1 uses this
  // for its practice, listen and play stages.
  void updateStages(double dt) {}

  // Lets a level use its own text for a phase (e.g. naming
  // the notes it teaches). Return null to use the normal
  // text from phase.dart.
  String? descriptionFor(GamePhase phase, {required bool isUpNext}) => null;

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

  @override
  void update(double dt) {
    noteSpawnTimer += dt;

    if (introActive == true) {
      introTrack += dt;
    }

    if (timelineActive == true) {
      timelineTrack += dt;
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

    // Intro 2: after "HOW TO PLAY", start the timeline.

    if (introStep == 1 &&
        introTrack >= introFinishedAt + GameConstants.howToPlayTime) {
      introActive = false;
      timelineActive = true;
      introStep = 2;
    }

    // Run each timeline event once its time comes.

    while (timelineActive == true &&
        timelineStep < timelineEvents.length &&
        timelineTrack >= timelineEvents[timelineStep].time) {
      timelineEvents[timelineStep].action();
      timelineStep++;
    }

    updateStages(dt);
  }

  // Adds the learning steps for one new note to [events],
  // starting at [time]: the note's text first, then (after
  // some reading time) the note is sent towards the worm a
  // couple of times. Returns the time once the last of
  // those notes has passed the worm, so the next note's
  // text only appears after that.
  double addLearningNote(
      List<LevelEvent> events,
      double time,
      String note,
      PhaseMessage message,
      ) {
    events.add(
      LevelEvent(time, () {
        game.showMessage(
          message,
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

    return time;
  }

  // ------------------------------------------------------------
  // NOTE HELPERS
  // One call sends one note at the given height
  // ('B', 'C', 'D', 'E', 'F', 'G', 'A' or 'b').
  // ------------------------------------------------------------

  // Practice phase: a long or short note to catch.
  void practiceNote(String lane) {
    setNoteLane(lane);
    spawnNote();
  }

  void practiceShortNote(String lane) {
    setNoteLane(lane);
    spawnShortNote();
  }

  // Listen phase: a note that plays by itself, with
  // the LISTEN banner.
  void listenNote(String lane) {
    spawnListen();
    setNoteLane(lane);
    spawnTeach();
  }

  // Play phase: a note to catch, with the PLAY banner.
  void playNote(String lane) {
    spawnPlay();
    setNoteLane(lane);
    spawnTest();
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

  void spawnDrum() {
    final timeline = TimeLine(
      Vector2(noteSpawnX, game.staffTopY - (game.noteSpriteHeight / 2)),
      Vector2(10, game.staffHeight + game.noteSpriteHeight),
    );
    game.add(timeline);
  }
}