import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wormsounds/constants/game_constants.dart';
import 'package:wormsounds/game/difficulty.dart';
import 'package:wormsounds/game/keys.dart';
import 'package:wormsounds/game/levelresult.dart';

void main() {
  group('PianoKeys', () {
    testWidgets(
      'displays all configured piano keys',
          (WidgetTester tester) async {
        String? pressedNote;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PianoKeys(
                height: GameConstants.pianoKeyHeightPortrait,
                onNotePressed: (note) {
                  pressedNote = note;
                },
              ),
            ),
          ),
        );

        // Check that every note defined for the keyboard appears.
        for (final note in GameConstants.whiteNotes) {
          expect(
            find.text(note),
            findsOneWidget,
          );
        }

        expect(
          pressedNote,
          isNull,
        );
      },
    );

    testWidgets(
      'returns the correct note when a key is pressed',
          (WidgetTester tester) async {
        String? pressedNote;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PianoKeys(
                height: GameConstants.pianoKeyHeightPortrait,
                onNotePressed: (note) {
                  pressedNote = note;
                },
              ),
            ),
          ),
        );

        await tester.tap(
          find.text('G'),
        );

        await tester.pump();

        expect(
          pressedNote,
          'G',
        );
      },
    );
  });

  group('Difficulty ratings', () {
    test(
      'easy difficulty uses relaxed rating thresholds',
          () {
        expect(
          Difficulty.easy.ratingFor(85),
          'A+',
        );
      },
    );

    test(
      'normal difficulty uses standard rating thresholds',
          () {
        expect(
          Difficulty.normal.ratingFor(85),
          'A',
        );
      },
    );

    test(
      'hard difficulty uses strict rating thresholds',
          () {
        expect(
          Difficulty.hard.ratingFor(85),
          'B',
        );
      },
    );
  });

  group('LevelResult', () {
    test(
      'calculates percentage and rating correctly',
          () {
        const result = LevelResult(
          score: 850,
          maxScore: 1000,
          notesHit: 12,
          notesTotal: 15,
          difficulty: Difficulty.normal,
        );

        expect(
          result.percent,
          85,
        );

        expect(
          result.rating,
          'A',
        );
      },
    );

    test(
      'formats scores with commas',
          () {
        expect(
          formatScore(9750),
          '9,750',
        );
      },
    );
  });
}