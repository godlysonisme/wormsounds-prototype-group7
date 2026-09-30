import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

// Shows the current (or upcoming) phase and a short
// explanation of what to do, on a dark panel so it is
// easy to read over the background.
class PhaseText extends PositionComponent {
  PhaseText()
      : super(
    anchor: Anchor.bottomCenter,
    priority: 10,
  );

  static const double _horizontalPadding = 14;
  static const double _verticalPadding = 8;
  static const double _lineGap = 2;

  final TextComponent _title = TextComponent(
    anchor: Anchor.topCenter,
    textRenderer: TextPaint(
      style: const TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    ),
  );

  final TextComponent _description = TextComponent(
    anchor: Anchor.topCenter,
    textRenderer: TextPaint(
      style: const TextStyle(
        color: Color(0xFFE0E0E0),
        fontSize: 13,
      ),
    ),
  );

  final Paint _panelPaint = Paint()
    ..color = const Color(0xAA000000);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    addAll([
      _title,
      _description,
    ]);
  }

  void show(String title, String description) {
    _title.text = title;
    _description.text = description;

    // Resize the panel to fit the new text.
    final width =
        math.max(_title.width, _description.width) +
            (_horizontalPadding * 2);

    final height = _verticalPadding +
        _title.height +
        _lineGap +
        _description.height +
        _verticalPadding;

    size = Vector2(width, height);

    _title.position = Vector2(
      width / 2,
      _verticalPadding,
    );

    _description.position = Vector2(
      width / 2,
      _verticalPadding + _title.height + _lineGap,
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