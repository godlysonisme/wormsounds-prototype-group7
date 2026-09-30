import 'package:flame/components.dart';
import 'package:wormsounds/game/worm_sounds_game.dart';
import 'package:wormsounds/game/phase.dart';

// An invisible marker that moves along with the notes.
// When it reaches the worm it updates the phase text, so
// the text always changes in time with the notes on screen,
// no matter how wide the screen is.
class PhaseMarker extends PositionComponent
    with HasGameReference<WormSoundsGame> {
  final GamePhase phase;
  final bool isUpNext;

  PhaseMarker(Vector2 position, {required this.phase, this.isUpNext = false})
      : super(position: position);

  @override
  void update(double dt) {
    // Same speed as the notes.
    position.x -= 200 * dt;
    if (position.x <= game.wormX) {
      game.showPhase(phase, isUpNext: isUpNext);
      removeFromParent();
    }
  }
}