import 'dart:async';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

import '../constants/game_constants.dart';

// Loads one sound for each worm height and plays it at
// normal volume when a note is hit, or quietly when the
// note is missed.
class NoteSounds {
  // An audio pool keeps players ready to go, so the sound
  // starts straight away instead of loading each time.
  final Map<String, AudioPool> _pools = {};

  Future<void> load() async {
    await Future.wait(
      GameConstants.noteSounds.entries.map((entry) async {
        try {
          _pools[entry.key] = await FlameAudio.createPool(
            entry.value,
            maxPlayers: 2,
          );
        } catch (e) {
          // If a sound can't load, keep the game running without it.
          debugPrint('Could not load ${entry.value}: $e');
        }
      }),
    );
  }

  void play(String note, {required bool isHit}) {
    final pool = _pools[note];

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