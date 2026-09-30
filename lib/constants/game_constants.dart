import 'package:flutter/material.dart';

class GameConstants {
  // Worm
  static const double wormSize = 80;
  static const double minWormSize = 48;
  static const double wormMovementSpeed = 500;

  // How far across the screen the worm sits
  // (0 = left edge, 1 = right edge).
  static const double wormHorizontalPosition = 0.2;

  // Staff
  static const double maxStaffLineSpacing = 45;
  static const double minStaffLineSpacing = 40;

  static const double staffSidePadding = 20;
  static const double staffLineThickness = 2;

  static const double staffVerticalPosition = 0.68;

  // Phases
  // Extra seconds of break between each phase so the
  // player has time to read the phase text.
  static const double phaseBreakDuration = 3;

  // Space kept free above the staff for the phase text.
  static const double phaseTextAreaHeight = 92;

  // Gap between the phase text and the top staff line.
  static const double phaseTextGap = 28;

  // Piano
  static const double pianoKeyHeightPortrait = 110;
  static const double pianoKeyHeightLandscape = 75;

  static const List<String> whiteNotes = [
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'A',
    'b',
  ];

  // Colours
  static const Color backgroundColor =
  Color(0xFF87CEEB);

  static const Color staffColor =
  Color(0xFF444444);

  static const Color pianoWhite =
      Colors.white;

  static const Color pianoBlack =
      Colors.black;
}