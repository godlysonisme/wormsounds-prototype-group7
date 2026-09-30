import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:wormsounds/game/worm.dart';
import 'package:wormsounds/game/worm_sounds_game.dart';

import '../constants/game_constants.dart';

// Shared behaviour for every note the worm can hit:
// a hitbox that only covers the note's own line/space,
// working out whether the worm hit or missed the note,
// and playing the note's sound (quietly if missed).
mixin PlayableNote
    on PositionComponent, CollisionCallbacks, HasGameReference<WormSoundsGame> {
  // Which worm height this note is on (e.g. 'B', 'F', 'b').
  String get lane;

  // Notes in the listen phase always play at normal
  // volume, since the player is only meant to listen.
  bool get alwaysPlaysLoud => false;

  // True once this note has played its sound.
  bool hasPlayed = false;

  // True if the worm hit this note (useful for scoring).
  bool wasHit = false;

  // A thin hitbox through the middle of the note, so the
  // worm on the line/space next to it can't touch it.
  RectangleHitbox createNoteHitbox() {
    final hitboxHeight =
        size.y * GameConstants.noteHitboxHeightRatio;

    return RectangleHitbox(
      position: Vector2(0, (size.y - hitboxHeight) / 2),
      size: Vector2(size.x, hitboxHeight),
      // Solid, so it still counts while the worm is fully inside it.
      isSolid: true,
      // Passive, so notes only check against the worm, not each other.
      collisionType: CollisionType.passive,
    );
  }

  // Call from update(). Plays listen phase notes as they
  // reach the worm, and plays missed notes quietly once
  // they are too far past the worm to be hit.
  void checkNoteSound() {
    if (hasPlayed) return;

    if (alwaysPlaysLoud) {
      if (position.x <= game.wormX) {
        playNoteSound(isHit: true);
      }
      return;
    }

    if (position.x < game.wormX - GameConstants.lateHitWindow) {
      playNoteSound(isHit: false);
    }
  }

  void playNoteSound({required bool isHit}) {
    hasPlayed = true;
    wasHit = isHit;
    game.noteSounds.play(lane, isHit: isHit);
  }

  // A hit only counts if the worm is touching the note AND
  // the worm was sent to this note's height. This stops a
  // note counting as hit when the worm just passes through
  // it on the way to a different height.
  void _checkHit(PositionComponent other) {
    if (hasPlayed || alwaysPlaysLoud) return;

    if (other is Worm && game.wormNote == lane) {
      playNoteSound(isHit: true);
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    _checkHit(other);
  }

  @override
  void onCollision(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollision(intersectionPoints, other);
    _checkHit(other);
  }
}