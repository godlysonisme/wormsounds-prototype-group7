import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:wormsounds/constants/game_constants.dart';
import 'package:wormsounds/game/worm_sounds_game.dart';
import 'dart:async';
import 'package:flame_audio/flame_audio.dart';


class TimeLine extends SpriteComponent
    with CollisionCallbacks, HasGameReference<WormSoundsGame> {
  TimeLine(Vector2 position, Vector2 size)
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    /*await FlameAudio.audioCache.loadAll([
      'drumloop.mp3',
    ]);*/

    sprite = await Sprite.load(
      'black.png',
    );
  }

  @override
  void update(double dt) {
    position.x -= 200 * dt;
    /*
    if (position.x <= GameConstants.wormHorizontalPosition) {
      FlameAudio.play('drumloop.mp3');
    }*/
    if (position.x <= GameConstants.wormHorizontalPosition -1) {
      removeFromParent();
    }
  }
}

