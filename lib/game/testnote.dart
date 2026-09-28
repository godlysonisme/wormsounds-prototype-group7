import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:wormsounds/game/worm_sounds_game.dart';
import 'dart:async';

class TestNote extends SpriteComponent
    with CollisionCallbacks, HasGameReference<WormSoundsGame> {
  final bool isTesting;

  TestNote(Vector2 position, Vector2 size, {required this.isTesting})
      : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('tester.png');

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    position.x -= 200 * dt;
    if (position.x + size.x <= 0) {
      removeFromParent();
    }
  }
}
