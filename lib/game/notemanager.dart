import 'package:flame/components.dart';
import 'package:wormsounds/game/worm_sounds_game.dart';
import 'shortnote.dart';
import 'package:wormsounds/game/note.dart';

class NoteManager extends Component
    with HasGameReference<WormSoundsGame> {

  double noteSpawnTimer = 0;

  double stage1Track = 0;
  bool stage1Active = false;

  double stage2Track = 0;
  bool stage2Active = false;

  double stage3Track = 0;
  bool stage3Active = false;

  double noteHeight = 0;
  bool spawnie = false;


  @override
  void update(double dt) {
    noteSpawnTimer += dt;

    if (stage1Active == true) {
      stage1Track += dt;
    }

    if (stage2Active == true) {
      stage2Track += dt;
    }

    // Stage 1: Root and Octave

    if (noteSpawnTimer >= 1 && spawnie == false && noteSpawnTimer <= 1.1) {
      stage1Active = true;
      noteHeight = 600;
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage1Track >= 2 && spawnie == true && stage1Track <= 2.2) {
      noteHeight = 430;
      spawnShortNote();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage1Track >= 4 && spawnie == false && stage1Track <= 4.1) {
      noteHeight = 430;
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage1Track >= 6 && spawnie == true && stage1Track <= 6.5) {
      noteHeight = 600;
      spawnShortNote();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    // Stage 2: Root and Middle

    if (stage1Track >= 8 && spawnie == false && stage1Track <= 8.1) {
      stage1Active = false;
      stage2Active = true;
      noteHeight = 600;
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage2Track >= 8 && spawnie == true && stage2Track <= 8.1) {
      noteHeight = 500;
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = false;
    }


    // Stage 3: Middle and Octave


  }

  void spawnShortNote() {
    final shortNote = ShortNote(
      Vector2(500, noteHeight),
      Vector2(250, 48),
      isSharpNote: false,
    );
    game.add(shortNote);
  }

    void spawnNote() {
      final note = Note(
        Vector2(500, noteHeight),
        Vector2(250, 48),
        isSharpNote: false,
      );
      game.add(note);
    }







}