import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'worm.dart';

import '../constants/game_constants.dart';

class WormSoundsGame extends FlameGame {
  Worm? _worm;

  final Map<String, double> _notePositions = {};

  late double _staffBottomY;
  late double _staffLineSpacing;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _createStaff();
    _calculateNotePositions();

    final worm = Worm(
      position: Vector2(
        size.x * 0.5,
        _notePositions['E']!,
      ),
    );

    _worm = worm;

    add(worm);
  }

  void _createStaff() {
    _staffLineSpacing = GameConstants.staffLineSpacing;

    // Position the staff roughly in the
    // middle/lower part of the game area.
    _staffBottomY =
        size.y * GameConstants.staffVerticalPosition;

    final staffWidth = size.x - (GameConstants.staffSidePadding * 2);

    final staffPaint = Paint()
      ..color = GameConstants.staffColor;

    // Five normal staff lines.
    for (int i = 0; i < 5; i++) {
      final y =
          _staffBottomY -
              (i * _staffLineSpacing);

      add(
        RectangleComponent(
          position: Vector2(
            GameConstants.staffSidePadding, y,
          ),
          size: Vector2(
            staffWidth, GameConstants.staffLineThickness,
          ),
          paint: staffPaint,
        ),
      );
    }

    // Ledger line for middle C.
    add(
      RectangleComponent(
        position: Vector2(
          (size.x / 2) - 55,
          _staffBottomY +
              _staffLineSpacing,
        ),
        size: Vector2(
          110,
          2,
        ),
        paint: staffPaint,
      ),
    );
  }

  void _calculateNotePositions() {
    final halfStep =
        _staffLineSpacing / 2;

    // C4-B4 positions on a treble staff.
    //
    // Screen Y increases downward,
    // therefore higher notes have
    // smaller Y values.

    _notePositions['C'] =
        _staffBottomY +
            _staffLineSpacing;

    _notePositions['D'] =
        _staffBottomY +
            halfStep;

    _notePositions['E'] =
        _staffBottomY;

    _notePositions['F'] =
        _staffBottomY -
            halfStep;

    _notePositions['G'] =
        _staffBottomY -
            _staffLineSpacing;

    _notePositions['A'] =
        _staffBottomY -
            (_staffLineSpacing * 1.5);

    _notePositions['B'] =
        _staffBottomY -
            (_staffLineSpacing * 2);
  }

  void moveWormToNote(String note) {
    final worm = _worm;

    if (worm == null) {
      return;
    }

    final targetY =
    _notePositions[note];

    if (targetY == null) {
      return;
    }

    worm.moveToY(targetY);
  }
}