import 'dart:typed_data';
import 'dart:ui' show ImageShader, TileMode;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:wormsounds/game/worm_sounds_game.dart';

// Fills the game area with BG.png. The image is a
// seamless tile, so it is repeated rather than stretched,
// which keeps the pixel art crisp on any screen size.
class Background extends PositionComponent
    with HasGameReference<WormSoundsGame> {
  Background() : super(priority: -1);

  final Paint _paint = Paint()
    ..filterQuality = FilterQuality.none;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final image = await game.images.load(
      'BG.png',
    );

    // Identity matrix: draw the tile at its normal size.
    final matrix = Float64List.fromList([
      1, 0, 0, 0,
      0, 1, 0, 0,
      0, 0, 1, 0,
      0, 0, 0, 1,
    ]);

    _paint.shader = ImageShader(
      image,
      TileMode.repeated,
      TileMode.repeated,
      matrix,
      filterQuality: FilterQuality.none,
    );
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    size = gameSize.clone();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      _paint,
    );
  }
}