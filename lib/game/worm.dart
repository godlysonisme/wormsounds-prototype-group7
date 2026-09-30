import 'package:flame/components.dart';

import '../constants/game_constants.dart';

class Worm extends SpriteComponent {
  Worm({
    required super.position,
  }) : super(
    size: Vector2.all(
      GameConstants.wormSize,
    ),
    // The worm's body sits in the lower part of
    // Worm.png (the top rows are empty), so anchor
    // on the body instead of the image centre.
    // This keeps the worm flush with the notes.
    anchor: const Anchor(0.5, 0.71),
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