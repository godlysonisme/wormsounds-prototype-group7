import 'package:flame/collisions.dart';
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
    anchor: const Anchor(0.5, bodyCentreY),
  );

  // How far down the image the middle of the body is.
  static const double bodyCentreY = 0.71;

  late double targetY;

  // Thin hitbox through the middle of the worm's body.
  // Given a size and position so it doesn't fill the
  // whole (mostly empty) image.
  final RectangleHitbox _hitbox = RectangleHitbox(
    position: Vector2.zero(),
    size: Vector2.zero(),
    collisionType: CollisionType.active,
  );

  final double movementSpeed =
      GameConstants.wormMovementSpeed;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await Sprite.load(
      'Worm.png',
    );

    targetY = position.y;

    _updateHitbox();
    add(_hitbox);

    // The worm is resized when the screen rotates,
    // so keep the hitbox matched to its new size.
    size.addListener(_updateHitbox);
  }

  void _updateHitbox() {
    final hitboxWidth =
        size.x * GameConstants.wormHitboxWidthRatio;

    final hitboxHeight =
        size.y * GameConstants.wormHitboxHeightRatio;

    _hitbox
      ..size = Vector2(
        hitboxWidth,
        hitboxHeight,
      )
      ..position = Vector2(
        (size.x - hitboxWidth) / 2,
        (size.y * bodyCentreY) - (hitboxHeight / 2),
      );
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