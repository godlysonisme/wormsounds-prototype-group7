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

// Spawns the notes, banners, phase markers and drum line used
// by the levels. Each note plays its own sound when it reaches
// the worm (see playablenote.dart).
//
// This class does NOT decide what is spawned or when. Each level
// (level1.dart, level2.dart, level3.dart) extends this class and
// maps out its own notes, messages and phases in its update().
//
// To send a note from a level:
//   setNoteLane('F');   // which height: 'B' 'C' 'D' 'E' 'F' 'G' 'A' 'b'
//   spawnNote();        // or spawnShortNote(), spawnLearningNote(),
//                       // spawnTeach() (listen) or spawnTest() (play)
abstract class NoteManager extends Component
    with HasGameReference<WormSoundsGame> {

  // Notes are sent from x = 500 at 200 pixels per second.
  static const double noteSpawnX = 500;
  static const double noteSpeed = 200;

  // The height the next note is sent at (set by setNoteLane).
  double noteHeight = 0;
  String noteLane = 'B';

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

  // ------------------------------------------------------------
  // SPAWN FUNCTIONS
  // ------------------------------------------------------------

  // Practice phase note (short). Counts towards the score.
  void spawnShortNote() {
    final shortNote = ShortNote(
      Vector2(500, noteHeight),
      Vector2(shortNoteLength, game.noteSpriteHeight),
      isSharpNote: false,
      lane: noteLane,
    );
    game.add(shortNote);
  }

  // Practice phase note (long). Counts towards the score.
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

  // Listen phase note: invisible, and plays by itself when it
  // reaches the worm. Not scored. Send with spawnListen().
  void spawnTeach() {
    final testnote = TestNote(
      Vector2(500, noteHeight),
      Vector2(GameConstants.longNoteLength, game.noteSpriteHeight),
      isTesting: false,
      lane: noteLane,
    );
    game.add(testnote);
  }

  // Play phase note: invisible, and must be caught by the
  // player. Counts towards the score. Send with spawnPlay().
  void spawnTest() {
    final testnote = TestNote(
      Vector2(500, noteHeight),
      Vector2(GameConstants.longNoteLength, game.noteSpriteHeight),
      isTesting: true,
      lane: noteLane,
    );
    game.add(testnote);
  }

  // The amber LISTEN banner that sweeps across the staff.
  void spawnListen() {
    final listen = Listen(
      Vector2(500, game.staffTopY - (game.noteSpriteHeight / 2)),
      Vector2(40, game.staffHeight + game.noteSpriteHeight),
    );
    game.add(listen);
  }

  // The orange PLAY banner that sweeps across the staff.
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

  // Drum line that moves with the notes (see timeline.dart).
  void spawnDrum() {
    final timeline = TimeLine(
      Vector2(noteSpawnX, game.staffTopY - (game.noteSpriteHeight / 2)),
      Vector2(3, game.staffHeight + game.noteSpriteHeight),
    );
    game.add(timeline);
  }
}
