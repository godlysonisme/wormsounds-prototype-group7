import 'package:flutter/material.dart';

import '../constants/game_constants.dart';

class PianoKeys extends StatelessWidget {
  const PianoKeys({
    super.key,
    required this.onNotePressed,
    required this.height,
  });

  final ValueChanged<String> onNotePressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        children: GameConstants.whiteNotes.map((note) {
          return Expanded(
            child: TextButton(
              onPressed: () {
                onNotePressed(note);
              },
              style: TextButton.styleFrom(
                foregroundColor:
                GameConstants.pianoBlack,
                backgroundColor:
                GameConstants.pianoWhite,
                minimumSize: Size(
                  0,
                  height,
                ),
                padding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                side: BorderSide(
                  color: GameConstants.pianoBlack,
                  width: 1,
                ),
              ),
              child: Text(
                note,
                style: TextStyle(
                  fontSize: height < 90 ? 16 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}