import 'package:flutter/material.dart';

class GameConstants {
  // Worm
  static const double wormSize = 80;
  static const double minWormSize = 48;
  static const double wormMovementSpeed = 500;

  // How far across the screen the worm sits
  // (0 = left edge, 1 = right edge).
  static const double wormHorizontalPosition = 0.2;

  // Size of the worm's hitbox compared to the worm.
  // It is a thin strip through the middle of its body.
  static const double wormHitboxWidthRatio = 0.3;
  static const double wormHitboxHeightRatio = 0.12;

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

  // Notes
  // Length of a long note. At the note speed of 200 this
  // is 1 second, leaving a 0.5 second gap between notes
  // that are 1.5 seconds apart, so notes never overlap
  // and the worm has time to move between them.
  static const double longNoteLength = 200;

  // Height of a note compared to the gap between staff
  // lines, so each note stays within its own line/space.
  static const double noteHeightRatio = 0.8;

  // Height of a note's hitbox compared to the note. The
  // hitbox is a thin strip through the middle, so it can
  // never reach the worm on the line/space next to it.
  static const double noteHitboxHeightRatio = 0.4;

  // How far (in pixels) a note can travel past the worm
  // and still count as a hit if the worm arrives late.
  // 24 pixels is 0.12 seconds at the note speed of 200.
  static const double lateHitWindow = 24;

  // Sound
  static const double noteVolume = 1.0;
  static const double missedNoteVolume = 0.2;

  // One sound per worm height (files are in assets/audio).
  // Lower-case file names so 'B' and 'b' don't clash on
  // Windows/macOS, which ignore upper/lower case.
  static const Map<String, String> noteSounds = {
    'B': 'b3.wav',
    'C': 'c4.wav',
    'D': 'd4.wav',
    'E': 'e4.wav',
    'F': 'f4.wav',
    'G': 'g4.wav',
    'A': 'a4.wav',
    'b': 'b4.wav',
  };

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