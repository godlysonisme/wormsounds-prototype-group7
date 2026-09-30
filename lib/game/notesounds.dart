import 'dart:async';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

import '../constants/game_constants.dart';

// Loads one sound for each worm height (plus a vibrato
// version of each) and plays it at normal volume when a
// note is hit, or quietly when the note is missed.
class NoteSounds {
  NoteSounds._();

  // One shared set of sounds for the whole app, so
  // restarting the level doesn't load them all again.
  static final NoteSounds shared = NoteSounds._();

  // An audio pool keeps players ready to go, so the sound
  // starts straight away instead of loading each time.
  final Map<String, AudioPool> _pools = {};
  final Map<String, AudioPool> _vibratoPools = {};

  Future<void>? _loading;

  // Safe to call more than once; sounds only load the first time.
  Future<void> load() {
    return _loading ??= _loadAll();
  }

  Future<void> _loadAll() async {
    await Future.wait(
      GameConstants.noteSounds.entries.expand((entry) {
        // e.g. 'f4.wav' -> 'f4_vibrato.wav'
        final vibratoFile =
        entry.value.replaceAll('.wav', '_vibrato.wav');

        return [
          _loadPool(_pools, entry.key, entry.value),
          _loadPool(_vibratoPools, entry.key, vibratoFile),
        ];
      }),
    );
  }

  Future<void> _loadPool(
      Map<String, AudioPool> pools,
      String note,
      String file,
      ) async {
    try {
      pools[note] = await FlameAudio.createPool(
        file,
        maxPlayers: 2,
      );
    } catch (e) {
      // If a sound can't load, keep the game running without it.
      debugPrint('Could not load $file: $e');
    }
  }

  void play(String note, {required bool isHit, bool vibrato = false}) {
    final pool = vibrato
        ? (_vibratoPools[note] ?? _pools[note])
        : _pools[note];

    if (pool == null) return;

    final volume = isHit
        ? GameConstants.noteVolume
        : GameConstants.missedNoteVolume;

    unawaited(_start(pool, volume));
  }

  Future<void> _start(AudioPool pool, double volume) async {
    try {
      await pool.start(volume: volume);
    } catch (e) {
      debugPrint('Could not play note: $e');
    }
  }
}