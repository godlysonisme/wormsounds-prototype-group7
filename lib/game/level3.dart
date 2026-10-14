import 'package:wormsounds/game/notemanager.dart';
import 'package:wormsounds/game/phasedlevel.dart';

// Needed for PhaseMessage once learning notes are added.
// ignore: unused_import
import 'package:wormsounds/game/phase.dart';

// LEVEL 3: placeholder, no notes yet.

// It already goes through the same phases as level 1 (Intro,
// Learning, Practice, Listen, Play), but each phase is empty.
// Add notes to the lists below and the phase text, breaks
// and timing are worked out automatically (see phasedlevel.dart).
// Keep notes in a phase at least 1.5 seconds apart so they don't
// overlap (a long note is 1 second long). Also update this level's
// description on the title screen in level.dart once it has notes.

class Level3NoteManager extends PhasedNoteManager {

  @override
  List<LearningNote> get learningNotes => const [



  ];

  @override
  List<LevelEvent> get practiceNotes => [



  ];

  @override
  List<LevelEvent> get listenNotes => [



  ];

  @override
  List<LevelEvent> get playNotes => [



  ];
}