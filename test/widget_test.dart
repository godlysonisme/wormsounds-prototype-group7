import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wormsounds/game/keys.dart';

void main() {
  testWidgets(
    'Piano keys display C through B',
        (WidgetTester tester) async {
      String? pressedNote;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PianoKeys(
              onNotePressed: (note) {
                pressedNote = note;
              },
            ),
          ),
        ),
      );

      expect(find.text('C'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
      expect(find.text('E'), findsOneWidget);
      expect(find.text('F'), findsOneWidget);
      expect(find.text('G'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);

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
}