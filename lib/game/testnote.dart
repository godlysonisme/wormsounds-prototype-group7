import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:wormsounds/game/worm_sounds_game.dart';
import 'dart:async';
import 'package:wormsounds/game/playablenote.dart';

class TestNote extends SpriteComponent
    with CollisionCallbacks, HasGameReference<WormSoundsGame>, PlayableNote {
  final bool isTesting;

  @override
  final String lane;

  TestNote(Vector2 position, Vector2 size, {required this.isTesting, required this.lane})
      : super(position: position, size: size);

  // Listen phase notes (not testing) always play at normal
  // volume. Play phase notes (testing) must be hit.
  @override
  bool get alwaysPlaysLoud => !isTesting;

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('tester.png');

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