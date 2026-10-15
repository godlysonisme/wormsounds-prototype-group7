import 'dart:math' as math;

import '../constants/game_constants.dart';
import 'notemanager.dart';
import 'phase.dart';

enum _EndlessState {
  intro,
  listen,
  beforePlay,
  play,
  beforeListen,
}

class EndlessNoteManager extends NoteManager {
  final math.Random _random = math.Random();

  _EndlessState _state =
      _EndlessState.intro;

  double _stateTime = 0;

  int _round = 1;

  List<String> _sequence = [];

  int _nextNoteIndex = 0;

  double _nextNoteAt = 0;

  double _phaseFinishAt = 0;

  String? _lastGeneratedNote;

  // ------------------------------------------------------------
  // TEXT
  // ------------------------------------------------------------

  @override
  String? descriptionFor(
      GamePhase phase, {
        required bool isUpNext,
      }) {
    switch (phase) {
      case GamePhase.intro:
        return 'Endless Mode creates random note sequences. '
            'Listen to each sequence, then play the same notes back. '
            'The sequences get longer as you complete more rounds.';

      case GamePhase.listen:
        if (isUpNext) {
          return 'Get ready to listen to the next random sequence.';
        }

        return 'Round $_round: Listen carefully and remember '
            'the notes and their order.';

      case GamePhase.play:
        if (isUpNext) {
          return 'Now play back the exact sequence you just heard.';
        }

        return 'Round $_round: Move the worm to reproduce '
            'the sequence you just heard.';

      default:
        return null;
    }
  }

  // ------------------------------------------------------------
  // MAIN LOOP
  // ------------------------------------------------------------

  @override
  void update(double dt) {
    super.update(dt);

    _stateTime += dt;

    switch (_state) {
      case _EndlessState.intro:
        _updateIntro();
        break;

      case _EndlessState.listen:
        _updateListen();
        break;

      case _EndlessState.beforePlay:
        _updateBeforePlay();
        break;

      case _EndlessState.play:
        _updatePlay();
        break;

      case _EndlessState.beforeListen:
        _updateBeforeListen();
        break;
    }
  }

  // ------------------------------------------------------------
  // INTRO
  // ------------------------------------------------------------

  void _updateIntro() {
    if (_stateTime >=
        GameConstants.endlessIntroTime) {
      _startListen();
    }
  }

  // ------------------------------------------------------------
  // LISTEN
  // ------------------------------------------------------------

  void _startListen() {
    _sequence =
        _generateSequence(
          _sequenceLength,
        );

    _state =
        _EndlessState.listen;

    _stateTime = 0;

    _prepareSequenceTiming();

    game.showPhase(
      GamePhase.listen,
    );
  }

  void _updateListen() {
    _spawnDueNotes(
      isPlayPhase: false,
    );

    if (_stateTime >=
        _phaseFinishAt) {
      _startBeforePlay();
    }
  }

  // ------------------------------------------------------------
  // TRANSITION TO PLAY
  // ------------------------------------------------------------

  void _startBeforePlay() {
    _state =
        _EndlessState.beforePlay;

    _stateTime = 0;

    game.showPhase(
      GamePhase.play,
      isUpNext: true,
    );
  }

  void _updateBeforePlay() {
    if (_stateTime >=
        GameConstants
            .endlessTransitionTime) {
      _startPlay();
    }
  }

  // ------------------------------------------------------------
  // PLAY
  // ------------------------------------------------------------

  void _startPlay() {
    _state =
        _EndlessState.play;

    _stateTime = 0;

    _prepareSequenceTiming();

    game.showPhase(
      GamePhase.play,
    );
  }

  void _updatePlay() {
    _spawnDueNotes(
      isPlayPhase: true,
    );

    if (_stateTime >=
        _phaseFinishAt) {
      _finishRound();
    }
  }

  // ------------------------------------------------------------
  // ROUND COMPLETE
  // ------------------------------------------------------------

  void _finishRound() {
    _state =
        _EndlessState.beforeListen;

    _stateTime = 0;

    game.showMessage(
      PhaseMessage(
        'ROUND $_round COMPLETE',
        'Get ready for the next sequence. '
            'The game will continue until you choose to exit.',
      ),
    );
  }

  void _updateBeforeListen() {
    if (_stateTime >=
        GameConstants
            .endlessRoundBreak) {
      _round++;

      _startListen();
    }
  }

  // ------------------------------------------------------------
  // NOTE SPAWNING
  // ------------------------------------------------------------

  void _prepareSequenceTiming() {
    _nextNoteIndex = 0;

    _nextNoteAt =
        GameConstants
            .endlessPhaseLeadIn;

    final lastNoteSpawnTime =
        GameConstants
            .endlessPhaseLeadIn +
            ((_sequence.length - 1) *
                GameConstants
                    .endlessNoteSpacing);

    _phaseFinishAt =
        lastNoteSpawnTime +
            _timeForNoteToReachWorm +
            GameConstants
                .endlessPostPhrasePause;
  }

  void _spawnDueNotes({
    required bool isPlayPhase,
  }) {
    while (
    _nextNoteIndex <
        _sequence.length &&
        _stateTime >=
            _nextNoteAt) {
      final note =
      _sequence[
      _nextNoteIndex
      ];

      setNoteLane(note);

      if (isPlayPhase) {
        // Show a PLAY timing bar for
        // every note.
        spawnPlay();

        // Invisible note that must
        // be caught by the player.
        spawnTest();
      } else {
        // Show a LISTEN timing bar
        // for every note.
        spawnListen();

        // Automatically plays the
        // note when it reaches the worm.
        spawnTeach();
      }

      _nextNoteIndex++;

      _nextNoteAt +=
          GameConstants
              .endlessNoteSpacing;
    }
  }

  // ------------------------------------------------------------
  // RANDOM SEQUENCE
  // ------------------------------------------------------------

  List<String> _generateSequence(
      int length,
      ) {
    final sequence =
    <String>[];

    String? previous =
        _lastGeneratedNote;

    for (int i = 0;
    i < length;
    i++) {
      final choices =
      GameConstants
          .whiteNotes
          .where(
            (note) =>
        note != previous,
      )
          .toList();

      final note =
      choices[
      _random.nextInt(
        choices.length,
      )
      ];

      sequence.add(note);

      previous = note;
    }

    _lastGeneratedNote =
        previous;

    return sequence;
  }

  // ------------------------------------------------------------
  // DIFFICULTY / ROUND LENGTH
  // ------------------------------------------------------------

  int get _sequenceLength {
    final increases =
        (_round - 1) ~/
            GameConstants
                .endlessRoundsPerIncrease;

    return math.min(
      GameConstants
          .endlessStartSequenceLength +
          increases,
      GameConstants
          .endlessMaxSequenceLength,
    );
  }

  // ------------------------------------------------------------
  // TIMING
  // ------------------------------------------------------------

  double get _timeForNoteToReachWorm {
    final distance =
        NoteManager.noteSpawnX -
            game.wormX;

    return math
        .max(
      0,
      distance /
          NoteManager.noteSpeed,
    )
        .toDouble();
  }
}