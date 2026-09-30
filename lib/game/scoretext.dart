import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:wormsounds/game/levelresult.dart';

import '../constants/game_constants.dart';

// Score counter in the top-right corner, on the same
// dark panel style as the phase text.
class ScoreText extends PositionComponent {
  ScoreText()
      : super(
    anchor: Anchor.topRight,
    priority: 10,
  );

  static const double _horizontalPadding = 14;
  static const double _verticalPadding = 6;

  final TextComponent _label = TextComponent(
    text: 'SCORE',
    anchor: Anchor.topCenter,
    textRenderer: TextPaint(
      style: const TextStyle(
        color: Color(0xFFE0E0E0),
        fontSize: 11,
        letterSpacing: 1.5,
      ),
    ),
  );

  final TextComponent _score = TextComponent(
    anchor: Anchor.topCenter,
    textRenderer: TextPaint(
      style: const TextStyle(
        color: GameConstants.listenAmber,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  final Paint _panelPaint = Paint()
    ..color = GameConstants.panelColor;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    addAll([
      _label,
      _score,
    ]);

    show(0);
  }

  void show(int score) {
    _score.text = formatScore(score);

    // Resize the panel to fit the number.
    final width =
        math.max(_label.width, math.max(_score.width, 64.0)) +
            (_horizontalPadding * 2);

    final height = _verticalPadding +
        _label.height +
        _score.height +
        _verticalPadding;

    size = Vector2(width, height);

    _label.position = Vector2(
      width / 2,
      _verticalPadding,
    );

    _score.position = Vector2(
      width / 2,
      _verticalPadding + _label.height,
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(10),
      ),
      _panelPaint,
    );
  }
}