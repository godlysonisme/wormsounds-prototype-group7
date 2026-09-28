import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:wormsounds/game/worm_sounds_game.dart';
import 'dart:async';

class Listen extends SpriteComponent
    with CollisionCallbacks, HasGameReference<WormSoundsGame> {
  Listen(Vector2 position, Vector2 size)
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await Sprite.load(
      'listen.png',
    );
  }

  @override
  void update(double dt) {
    position.x -= 200 * dt;
    if (position.x + size.x <= 0) {
      removeFromParent();
    }
  }
}
