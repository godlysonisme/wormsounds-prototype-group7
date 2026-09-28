import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../constants/game_constants.dart';
import 'worm.dart';
import 'package:wormsounds/game/notemanager.dart';

class WormSoundsGame extends FlameGame {
  Worm? _worm;
  late NoteManager noteManager;

  final Map<String, double> _notePositions = {};

  final List<RectangleComponent> _staffLines = [];

  RectangleComponent? _ledgerLine;



  double _staffBottomY = 0;
  double _staffLineSpacing = 0;

  String _currentNote = 'E';

  bool _staffCreated = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _createStaffComponents();

    _layoutGame(size);

    final worm = Worm(
      position: Vector2(
        size.x * 0.5,
        _notePositions[_currentNote]!,
      ),
    );

    _worm = worm;

    _resizeWorm();

    add(worm);

    noteManager = NoteManager();
    add(noteManager);

  }

  // ------------------------------------------------------------
  // CREATE STAFF
  // ------------------------------------------------------------

  void _createStaffComponents() {
    final staffPaint = Paint()
      ..color = GameConstants.staffColor;

    for (int i = 0; i < 5; i++) {
      final line = RectangleComponent(
        paint: staffPaint,
      );

      _staffLines.add(line);
      add(line);
    }

    _ledgerLine = RectangleComponent(
      paint: staffPaint,
    );

    add(_ledgerLine!);

    _staffCreated = true;
  }

  // ------------------------------------------------------------
  // RESPONSIVE LAYOUT
  // ------------------------------------------------------------

  void _layoutGame(Vector2 gameSize) {
    if (!_staffCreated) return;

    // The available height determines how far
    // apart the staff lines should be.
    final calculatedSpacing =
        gameSize.y * 0.085;

    _staffLineSpacing =
        calculatedSpacing.clamp(
          GameConstants.minStaffLineSpacing,
          GameConstants.maxStaffLineSpacing,
        ).toDouble();

    _staffBottomY =
        gameSize.y *
            GameConstants.staffVerticalPosition;

    final staffWidth =
        gameSize.x -
            (GameConstants.staffSidePadding * 2);

    // Position the five staff lines.
    for (int i = 0; i < _staffLines.length; i++) {
      final y =
          _staffBottomY -
              (i * _staffLineSpacing);

      _staffLines[i]
        ..position = Vector2(
          GameConstants.staffSidePadding,
          y,
        )
        ..size = Vector2(
          staffWidth,
          GameConstants.staffLineThickness,
        );
    }

    // Ledger line for middle C.
    final ledgerWidth =
    GameConstants.ledgerLineWidth
        .clamp(
      70,
      gameSize.x * 0.25,
    )
        .toDouble();

    _ledgerLine
      ?..position = Vector2(
        (gameSize.x - ledgerWidth) / 2,
        _staffBottomY +
            _staffLineSpacing,
      )
      ..size = Vector2(
        ledgerWidth,
        GameConstants.staffLineThickness,
      );

    _calculateNotePositions();

    // Keep the worm centred horizontally
    // when the orientation changes.
    final worm = _worm;

    if (worm != null) {
      worm.position.x =
          gameSize.x * 0.5;

      worm.position.y =
      _notePositions[_currentNote]!;

      worm.targetY =
      _notePositions[_currentNote]!;

      _resizeWorm();
    }
  }

  // ------------------------------------------------------------
  // NOTE LOCATIONS
  // ------------------------------------------------------------

  void _calculateNotePositions() {
    final halfStep =
        _staffLineSpacing / 2;

    _notePositions['B'] =
        _staffBottomY +
            _staffLineSpacing;

    _notePositions['C'] =
        _staffBottomY +
            halfStep;

    _notePositions['D'] =
        _staffBottomY;

    _notePositions['E'] =
        _staffBottomY -
            halfStep;

    _notePositions['F'] =
        _staffBottomY -
            _staffLineSpacing;

    _notePositions['G'] =
        _staffBottomY -
            (_staffLineSpacing * 1.5);

    _notePositions['A'] =
        _staffBottomY -
            (_staffLineSpacing * 2);

    _notePositions['b'] =
        _staffBottomY -
            (_staffLineSpacing * 2.5);
  }

  // ------------------------------------------------------------
  // RESPONSIVE WORM SIZE
  // ------------------------------------------------------------

  void _resizeWorm() {
    final worm = _worm;

    if (worm == null) return;

    final calculatedSize =
        _staffLineSpacing * 1.65;

    final wormSize =
    calculatedSize.clamp(
      GameConstants.minWormSize,
      GameConstants.wormSize,
    ).toDouble();

    worm.size =
        Vector2.all(wormSize);
  }

  // ------------------------------------------------------------
  // INPUT
  // ------------------------------------------------------------

  void moveWormToNote(String note) {
    final worm = _worm;

    if (worm == null) return;

    final targetY =
    _notePositions[note];

    if (targetY == null) return;

    _currentNote = note;

    worm.moveToY(targetY);
  }

  // ------------------------------------------------------------
  // SCREEN ROTATION / RESIZE
  // ------------------------------------------------------------

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    _layoutGame(gameSize);

  }




}