import 'package:wormsounds/game/notemanager.dart';
import 'package:wormsounds/game/phase.dart';
import '../constants/game_constants.dart';

// A new note introduced in the learning phase, with the
// text shown while it is being learned.
class LearningNote {
  const LearningNote(this.lane, this.message);

  final String lane;
  final PhaseMessage message;
}

// A level built from a list of notes for each phase. Used by
// levels 2 and 3. It goes through the same phases as level 1
// (Intro, Learning, Practice, Listen, Play) and puts in the
// phase text, "UP NEXT" breaks and timing automatically, so a
// level only has to list its notes.
//
// A phase with no notes still shows its text for a few
// seconds, so a level with no notes yet can still be played
// through from start to finish.
abstract class PhasedNoteManager extends NoteManager {

  // The new notes taught in the learning phase, in order.
  List<LearningNote> get learningNotes;

  // The notes for each phase. Each LevelEvent's time is
  // seconds after that phase starts.
  List<LevelEvent> get practiceNotes;
  List<LevelEvent> get listenNotes;
  List<LevelEvent> get playNotes;

  @override
  List<LevelEvent> buildTimeline() {
    final events = <LevelEvent>[];
    double time = 0;

    // LEARNING

    if (learningNotes.isEmpty) {
      events.add(
        LevelEvent(time, () => game.showPhase(GamePhase.learning)),
      );
      time += GameConstants.emptyPhaseTime;
    } else {
      for (final learningNote in learningNotes) {
        time = addLearningNote(
          events,
          time,
          learningNote.lane,
          learningNote.message,
        );
      }
    }

    // PRACTICE

    events.add(
      LevelEvent(time, () {
        game.showPhase(GamePhase.practice, isUpNext: true);
      }),
    );

    time += GameConstants.practiceReadTime;

    events.add(
      LevelEvent(time, () => spawnPhaseMarker(GamePhase.practice)),
    );

    time = _addPhaseNotes(events, time, practiceNotes);

    // "UP NEXT: LISTEN" once the last practice note has passed.
    events.add(
      LevelEvent(time, () {
        spawnPhaseMarker(GamePhase.listen, isUpNext: true, afterNote: true);
      }),
    );

    // LISTEN

    time += 2 + NoteManager.phaseBreak;

    events.add(
      LevelEvent(time, () => spawnPhaseMarker(GamePhase.listen)),
    );

    time = _addPhaseNotes(events, time, listenNotes);

    events.add(
      LevelEvent(time, () {
        spawnPhaseMarker(GamePhase.play, isUpNext: true, afterNote: true);
      }),
    );

    // PLAY

    time += 2 + NoteManager.phaseBreak;

    events.add(
      LevelEvent(time, () => spawnPhaseMarker(GamePhase.play)),
    );

    time = _addPhaseNotes(events, time, playNotes);

    // LEVEL COMPLETE once the last play note has passed.
    events.add(
      LevelEvent(time, () {
        spawnPhaseMarker(GamePhase.complete, afterNote: true);
      }),
    );

    return _sortedByTime(events);
  }

  // Adds a phase's notes, starting at [start]. Returns the
  // time of the phase's last note, or, if the phase has no
  // notes yet, a short pause so its text can still be read.
  double _addPhaseNotes(
      List<LevelEvent> events,
      double start,
      List<LevelEvent> notes,
      ) {
    if (notes.isEmpty) {
      return start + GameConstants.emptyPhaseTime;
    }

    double lastNoteTime = 0;

    for (final note in notes) {
      events.add(LevelEvent(start + note.time, note.action));

      if (note.time > lastNoteTime) {
        lastNoteTime = note.time;
      }
    }

    return start + lastNoteTime;
  }

  // Puts the events in time order (in case notes were listed
  // out of order). Events at the same time keep their order.
  List<LevelEvent> _sortedByTime(List<LevelEvent> events) {
    final order = List<int>.generate(events.length, (i) => i);

    order.sort((a, b) {
      final byTime = events[a].time.compareTo(events[b].time);
      return byTime != 0 ? byTime : a.compareTo(b);
    });

    return [for (final i in order) events[i]];
  }
}