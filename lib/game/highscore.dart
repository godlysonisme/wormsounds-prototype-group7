import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wormsounds/game/level.dart';

// Saves the player's best score for each level on the phone
// so it is still there next time they open the app.
class HighScore {
  static Future<int> load(GameLevel level) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(level.highScoreKey) ?? 0;
    } catch (e) {
      debugPrint('Could not load high score: $e');
      return 0;
    }
  }

  static Future<void> save(GameLevel level, int score) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(level.highScoreKey, score);
    } catch (e) {
      debugPrint('Could not save high score: $e');
    }
  }
}