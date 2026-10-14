import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/text.dart' show InlineTextElement;
import 'package:flutter/material.dart';

// Shows the current (or upcoming) phase and an explanation
// of what to do, on a dark panel so it is easy to read over
// the background. Long text wraps onto extra lines so it
// always fits on the screen.
class PhaseText extends PositionComponent {
  PhaseText()
      : super(
    anchor: Anchor.bottomCenter,
    priority: 10,
  );

  static const double _horizontalPadding = 14;
  static const double _verticalPadding = 8;
  static const double _titleGap = 3;
  static const double _lineGap = 1;

  // Never let the panel go higher than this from the
  // top of the screen.
  static const double _screenTopMargin = 4;

  final TextPaint _titlePaint = TextPaint(
    style: const TextStyle(
      color: Color(0xFFFFFFFF),
      fontSize: 18,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
    ),
  );

  final TextPaint _descriptionPaint = TextPaint(
    style: const TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 13,
    ),
  );

  final Paint _panelPaint = Paint()
    ..color = const Color(0xAA000000);

  String _title = '';
  String _description = '';

  // Where the panel goes, set by the game when the screen
  // size changes.
  double _centreX = 0;
  double _bottomY = 0;
  double _maxWidth = 360;

  // Each wrapped line, ready to draw. Worked out once when
  // the text changes, not every frame.
  final List<InlineTextElement> _lines = [];

  void setLayout({
    required double centreX,
    required double bottomY,
    required double maxWidth,
  }) {
    _centreX = centreX;
    _bottomY = bottomY;
    _maxWidth = maxWidth;
    _layout();
  }

  void show(String title, String description) {
    _title = title;
    _description = description;
    _layout();
  }

  void _layout() {
    final textWidth = math.max(
      _maxWidth - (_horizontalPadding * 2),
      80.0,
    );

    final titleLines = _wrap(_title, _titlePaint, textWidth);
    final descriptionLines =
    _wrap(_description, _descriptionPaint, textWidth);

    // Measure every line to find the panel size.
    double widest = 0;

    for (final line in titleLines) {
      widest = math.max(widest, _titlePaint.getLineMetrics(line).width);
    }

    for (final line in descriptionLines) {
      widest = math.max(
        widest,
        _descriptionPaint.getLineMetrics(line).width,
      );
    }

    final panelWidth = widest + (_horizontalPadding * 2);

    // Place each line, centred, one under the other.
    _lines.clear();
    double y = _verticalPadding;

    for (final line in titleLines) {
      y = _addLine(line, _titlePaint, panelWidth, y);
    }

    y += _titleGap;

    for (final line in descriptionLines) {
      y = _addLine(line, _descriptionPaint, panelWidth, y) + _lineGap;
    }

    size = Vector2(panelWidth, y - _lineGap + _verticalPadding);

    // Sit just above the staff, but if the text is very tall
    // (e.g. on a short landscape screen) keep it on screen.
    position = Vector2(
      _centreX,
      math.max(_bottomY, size.y + _screenTopMargin),
    );
  }

  // Adds one centred line at height [y] and returns the
  // height just below it.
  double _addLine(String text, TextPaint paint, double panelWidth, double y) {
    final element = paint.format(text);
    final metrics = element.metrics;

    element.translate(
      ((panelWidth - metrics.width) / 2) - metrics.left,
      y - metrics.top,
    );

    _lines.add(element);

    return y + metrics.height;
  }

  // Splits text into lines no wider than [maxWidth].
  List<String> _wrap(String text, TextPaint paint, double maxWidth) {
    final lines = <String>[];
    var current = '';

    for (final word in text.split(' ')) {
      if (word.isEmpty) continue;

      final attempt = current.isEmpty ? word : '$current $word';

      if (current.isEmpty ||
          paint.getLineMetrics(attempt).width <= maxWidth) {
        current = attempt;
      } else {
        lines.add(current);
        current = word;
      }
    }

    if (current.isNotEmpty) {
      lines.add(current);
    }

    return lines;
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

    for (final line in _lines) {
      line.draw(canvas);
    }
  }
}