import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:wormsounds/game/worm_sounds_game.dart';
import 'dart:async';
import 'package:wormsounds/game/playablenote.dart';

class ShortNote extends SpriteComponent
    with CollisionCallbacks, HasGameReference<WormSoundsGame>, PlayableNote {
  final bool isSharpNote;

  @override
  final String lane;

  // Only the left 72 x 48 pixels of short.png are drawn on,
  // the rest is see-through. Cropping to that part means the
  // hitbox matches what the player can actually see.
  static final Vector2 spriteArea = Vector2(72, 48);

  ShortNote(Vector2 position, Vector2 size, {required this.isSharpNote, required this.lane})
      : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load(
      isSharpNote ? 'short-sharp.png' : 'short.png',
      srcSize: spriteArea.clone(),
    );

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