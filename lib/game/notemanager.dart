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

class NoteManager extends Component
    with HasGameReference<WormSoundsGame> {

  double noteSpawnTimer = 0;

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

  @override
  void update(double dt) {
    noteSpawnTimer += dt;

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

    // Stage 1: Root and Octave

    if (noteSpawnTimer >= 1 && spawnie == false && noteSpawnTimer <= 1.1) {
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

    // Stage 4: Trial Teach

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

    // Stage 5: Test

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