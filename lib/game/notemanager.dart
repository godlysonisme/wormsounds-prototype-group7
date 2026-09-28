import 'package:flame/components.dart';
import 'package:wormsounds/game/worm_sounds_game.dart';
import 'shortnote.dart';
import 'package:wormsounds/game/note.dart';
import 'package:wormsounds/game/listen.dart';
import 'package:wormsounds/game/testnote.dart';
import 'package:wormsounds/game/play.dart';

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
      stage2Active = true;
      noteHeight = 600;
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage2Track >= 1 && spawnie == true && stage2Track <= 1.1) {
      noteHeight = 500;
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage2Track >= 2 && spawnie == false && stage2Track <= 2.1) {
      noteHeight = 500;
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage2Track >= 3 && spawnie == true && stage2Track <= 3.1) {
      noteHeight = 600;
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    // Stage 3: Middle and Octave

    if (stage2Track >= 5 && spawnie == false && stage2Track <= 5.1) {
      stage3Active = true;
      noteHeight = 500;
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage3Track >= 1 && spawnie == true && stage3Track <= 1.1) {
      noteHeight = 430;
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage3Track >= 2 && spawnie == false && stage3Track <= 2.1) {
      noteHeight = 430;
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage3Track >= 3 && spawnie == true && stage3Track <= 3.1) {
      noteHeight = 500;
      spawnNote();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    // Stage 4: Trial Teach

    if (stage3Track >= 5 && spawnie == false && stage3Track <= 5.1) {
      stage4Active = true;
      spawnListen();
      noteHeight = 600;
      spawnTeach();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage4Track >= 1.5 && spawnie == true && stage4Track <= 1.6) {
      spawnListen();
      noteHeight = 430;
      spawnTeach();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage4Track >= 3 && spawnie == false && stage4Track <= 3.1) {
      spawnListen();
      noteHeight = 500;
      spawnTeach();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    // Stage 5: Test

    if (stage4Track >= 5 && spawnie == true && stage4Track <= 5.1) {
      stage5Active = true;
      spawnPlay();
      noteHeight = 600;
      spawnTeach();
      noteSpawnTimer += 1;
      spawnie = false;
    }

    if (stage5Track >= 1.5 && spawnie == false && stage5Track <= 1.6) {
      spawnPlay();
      noteHeight = 430;
      spawnTeach();
      noteSpawnTimer += 1;
      spawnie = true;
    }

    if (stage5Track >= 3 && spawnie == true && stage5Track <= 3.1) {
      spawnPlay();
      noteHeight = 500;
      spawnTeach();
      noteSpawnTimer += 1;
      spawnie = false;
    }
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

  void spawnTeach() {
    final testnote = TestNote(
      Vector2(500, noteHeight),
      Vector2(250, 48),
      isTesting: false,
    );
    game.add(testnote);
  }

  void spawnTest() {
    final testnote = TestNote(
      Vector2(500, noteHeight),
      Vector2(250, 48),
      isTesting: true,
    );
    game.add(testnote);
  }

  void spawnListen() {
    final listen = Listen(
      Vector2(500, 300),
      Vector2(40, 480),
    );
    game.add(listen);
  }

  void spawnPlay() {
    final play = Play(
      Vector2(500, 300),
      Vector2(40, 480),
    );
    game.add(play);
  }
}