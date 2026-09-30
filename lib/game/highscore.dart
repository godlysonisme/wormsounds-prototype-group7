import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Saves the player's best score on the phone so it is
// still there next time they open the app.
class HighScore {
  static const String _key = 'highScore';

  static Future<int> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_key) ?? 0;
    } catch (e) {
      debugPrint('Could not load high score: $e');
      return 0;
    }
  }

  static Future<void> save(int score) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_key, score);
    } catch (e) {
      debugPrint('Could not save high score: $e');
    }
  }
}