import 'package:flutter/material.dart';

class GameConstants {
  // Worm
  static const double wormSize = 80;
  static const double minWormSize = 48;
  static const double wormMovementSpeed = 500;

  // Staff
  static const double maxStaffLineSpacing = 45;
  static const double minStaffLineSpacing = 24;

  static const double staffSidePadding = 20;
  static const double staffLineThickness = 2;

  static const double staffVerticalPosition = 0.62;

  static const double ledgerLineWidth = 110;

  // Piano
  static const double pianoKeyHeightPortrait = 110;
  static const double pianoKeyHeightLandscape = 75;

  static const List<String> whiteNotes = [
    'C',
    'D',
    'E',
    'F',
    'G',
    'A',
    'B',
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