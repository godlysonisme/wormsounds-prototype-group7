import 'package:flame/components.dart';

import '../constants/game_constants.dart';

class Worm extends SpriteComponent {
  Worm({
    required super.position,
  }) : super(
    size: Vector2.all(
      GameConstants.wormSize,
    ),
    anchor: Anchor.center,
  );

  late double targetY;

  final double movementSpeed =
      GameConstants.wormMovementSpeed;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await Sprite.load(
      'Worm.png',
    );

    targetY = position.y;
  }

  void moveToY(double newY) {
    targetY = newY;
  }

  @override
  void update(double dt) {
    super.update(dt);

    final distance =
        targetY - position.y;

    if (distance.abs() < 1) {
      position.y = targetY;
      return;
    }

    final maxMovement =
        movementSpeed * dt;

    if (distance.abs() <=
        maxMovement) {
      position.y = targetY;
    } else {
      position.y +=
          distance.sign *
              maxMovement;
    }
  }
}