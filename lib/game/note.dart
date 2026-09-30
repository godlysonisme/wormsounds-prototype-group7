import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:wormsounds/game/worm_sounds_game.dart';
import 'dart:async';
import 'package:wormsounds/game/playablenote.dart';

class Note extends SpriteComponent
    with CollisionCallbacks, HasGameReference<WormSoundsGame>, PlayableNote {
  final bool isSharpNote;

  @override
  final String lane;

  Note(Vector2 position, Vector2 size, {required this.isSharpNote, required this.lane})
      : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load(isSharpNote ? 'long-sharp.png' : 'long.png');

    add(createNoteHitbox());
  }

  @override
  void update(double dt) {
    checkNoteSound();
    position.x -= 200 * dt;
    if (position.x + size.x <= 0) {
      removeFromParent();
    }
  }
}