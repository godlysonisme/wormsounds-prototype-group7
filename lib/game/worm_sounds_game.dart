import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import '../constants/game_constants.dart';
import 'worm.dart';
import 'package:wormsounds/game/notemanager.dart';
import 'package:wormsounds/game/background.dart';
import 'package:wormsounds/game/phase.dart';
import 'package:wormsounds/game/phasetext.dart';

class WormSoundsGame extends FlameGame {
  Worm? _worm;
  late NoteManager noteManager;

  final Map<String, double> _notePositions = {};

  final List<RectangleComponent> _staffLines = [];

  final PhaseText _phaseText = PhaseText();

  // The phase the level is currently in. Updated by the
  // phase markers as each phase reaches the worm.
  GamePhase currentPhase = GamePhase.practice;

  double _staffBottomY = 0;
  double _staffLineSpacing = 0;

  String _currentNote = 'E';

  bool _staffCreated = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(Background());

    _createStaffComponents();

    add(_phaseText);

    _layoutGame(size);

    final worm = Worm(
      position: Vector2(
        size.x * GameConstants.wormHorizontalPosition,
        _notePositions[_currentNote]!,
      ),
    );

    _worm = worm;

    _resizeWorm();

    add(worm);

    noteManager = NoteManager();
    add(noteManager);

    // Tell the player what the first phase is
    // before any notes reach the worm.
    showPhase(
      GamePhase.practice,
      isUpNext: true,
    );
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

    // Keep enough room above the staff for the
    // phase text, which matters on short screens
    // such as landscape. The bottom note still
    // needs to fit on screen underneath.
    final minStaffBottomY =
        GameConstants.phaseTextAreaHeight +
            (_staffLineSpacing * 4);

    _staffBottomY = math.min(
      math.max(
        gameSize.y *
            GameConstants.staffVerticalPosition,
        minStaffBottomY,
      ),
      gameSize.y - (_staffLineSpacing * 0.7),
    ).toDouble();

    final staffWidth =
        gameSize.x -
            (GameConstants.staffSidePadding * 2);

    // Position the five staff lines. The worm's
    // lowest height (B) sits on the bottom line and
    // its highest height (b) sits in the top space,
    // so every height is either on a line or in the
    // middle of a space.
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

    // Phase text sits just above the top staff line.
    _phaseText.position = Vector2(
      gameSize.x / 2,
      staffTopY - GameConstants.phaseTextGap,
    );

    _calculateNotePositions();

    // Keep the worm on the left side of the
    // screen when the orientation changes.
    final worm = _worm;

    if (worm != null) {
      worm.position.x =
          gameSize.x *
              GameConstants.wormHorizontalPosition;

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

    // Each note is half a line spacing above the
    // last, alternating between lines and spaces.
    _notePositions['B'] =
        _staffBottomY;

    _notePositions['C'] =
        _staffBottomY -
            halfStep;

    _notePositions['D'] =
        _staffBottomY -
            _staffLineSpacing;

    _notePositions['E'] =
        _staffBottomY -
            (_staffLineSpacing * 1.5);

    _notePositions['F'] =
        _staffBottomY -
            (_staffLineSpacing * 2);

    _notePositions['G'] =
        _staffBottomY -
            (_staffLineSpacing * 2.5);

    _notePositions['A'] =
        _staffBottomY -
            (_staffLineSpacing * 3);

    _notePositions['b'] =
        _staffBottomY -
            (_staffLineSpacing * 3.5);
  }

  // Centre height of a note's line or space. The note
  // manager uses this so incoming notes spawn at exactly
  // the same heights the worm moves to.
  double noteHeightFor(String note) {
    return _notePositions[note] ?? _staffBottomY;
  }

  double get staffTopY =>
      _staffBottomY - (_staffLineSpacing * 4);

  double get staffHeight =>
      _staffLineSpacing * 4;

  double get wormX =>
      _worm?.position.x ?? 0;

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
  // PHASES
  // ------------------------------------------------------------

  void showPhase(GamePhase phase, {bool isUpNext = false}) {
    if (!isUpNext) {
      currentPhase = phase;
    }

    final title = isUpNext
        ? 'UP NEXT: ${phase.title}'
        : phase.title;

    _phaseText.show(
      title,
      phase.description,
    );
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