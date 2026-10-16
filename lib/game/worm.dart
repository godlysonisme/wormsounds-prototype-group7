import 'dart:math' as math;

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

    // Render the worm in front of notes,
    // timing bars and staff components.
    priority: 5,

    // The worm's body sits in the lower part of
    // Worm.png (the top rows are empty), so anchor
    // on the body instead of the image centre.
    anchor: const Anchor(
      0.5,
      bodyCentreY,
    ),
  );

  // How far down the image the middle
  // of the worm's body is.
  static const double bodyCentreY =
  0.71;

  late double targetY;

  // Thin hitbox through the middle of
  // the worm's body.
  final RectangleHitbox _hitbox =
  RectangleHitbox(
    position: Vector2.zero(),
    size: Vector2.zero(),
    collisionType:
    CollisionType.active,
  );

  final double movementSpeed =
      GameConstants
          .wormMovementSpeed;

  // Vibrato animation.
  bool isVibrato = false;

  late final Sprite
  _wingDownSprite;

  late final Sprite
  _wingUpSprite;

  bool _wingUp = false;

  double _flapTimer = 0;

  double _wobbleTime = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _wingDownSprite =
    await Sprite.load(
      'Worm.png',
    );

    _wingUpSprite =
    await Sprite.load(
      'WormFlap.png',
    );

    sprite =
        _wingDownSprite;

    targetY =
        position.y;

    _updateHitbox();

    add(
      _hitbox,
    );

    // Keep the hitbox matched when
    // the worm is resized.
    size.addListener(
      _updateHitbox,
    );
  }

  void _updateHitbox() {
    final hitboxWidth =
        size.x *
            GameConstants
                .wormHitboxWidthRatio;

    final hitboxHeight =
        size.y *
            GameConstants
                .wormHitboxHeightRatio;

    _hitbox
      ..size = Vector2(
        hitboxWidth,
        hitboxHeight,
      )
      ..position = Vector2(
        (size.x -
            hitboxWidth) /
            2,
        (size.y *
            bodyCentreY) -
            (hitboxHeight / 2),
      );
  }

  void moveToY(
      double newY,
      ) {
    targetY =
        newY;
  }

  @override
  void update(double dt) {
    super.update(dt);

    _updateVibrato(
      dt,
    );

    final distance =
        targetY -
            position.y;

    if (distance.abs() < 1) {
      position.y =
          targetY;

      return;
    }

    final maxMovement =
        movementSpeed * dt;

    if (distance.abs() <=
        maxMovement) {
      position.y =
          targetY;
    } else {
      position.y +=
          distance.sign *
              maxMovement;
    }
  }

  void _updateVibrato(
      double dt,
      ) {
    if (isVibrato) {
      _wobbleTime += dt;

      angle = math.sin(
        _wobbleTime *
            math.pi *
            2 *
            GameConstants
                .wormWobbleSpeed,
      ) *
          GameConstants
              .wormWobbleAngle;

      _flapTimer += dt;

      if (_flapTimer >=
          GameConstants
              .wormFlapInterval) {
        _flapTimer = 0;

        _wingUp =
        !_wingUp;

        sprite =
        _wingUp
            ? _wingUpSprite
            : _wingDownSprite;
      }
    } else if (_wobbleTime != 0 ||
        _wingUp) {
      _wobbleTime = 0;

      _flapTimer = 0;

      _wingUp = false;

      angle = 0;

      sprite =
          _wingDownSprite;
    }
  }
}