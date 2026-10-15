import 'package:flutter/material.dart';

import '../constants/game_constants.dart';
import '../game/level.dart';
import 'screen_widgets.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({
    super.key,
    required this.currentLevel,
  });

  final GameLevel currentLevel;

  static const List<GameLevel> playableLevels = [
    GameLevel.one,
    GameLevel.two,
    GameLevel.three,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SkyBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isLandscape =
                constraints.maxWidth >
                    constraints.maxHeight;

            final int columns =
            isLandscape ? 3 : 2;

            return Column(
              children: [
                // ------------------------------------------
                // HEADER
                // ------------------------------------------

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    8,
                  ),
                  child: Row(
                    children: [
                      Material(
                        color:
                        GameConstants.panelColor,
                        shape: const CircleBorder(),
                        clipBehavior:
                        Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const SizedBox(
                            width: 48,
                            height: 48,
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      const Expanded(
                        child: Text(
                          'LEVEL SELECT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight:
                            FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text(
                    'Choose a lesson to practise a musical interval.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFE0E0E0),
                      fontSize: 13,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ------------------------------------------
                // SCROLLABLE LEVEL GRID
                // ------------------------------------------

                Expanded(
                  child: GridView.builder(
                    padding:
                    const EdgeInsets.all(16),

                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio:
                      isLandscape
                          ? 1.7
                          : 1.05,
                    ),

                    // 3 real levels + 6 placeholders.
                    itemCount: 9,

                    itemBuilder: (
                        context,
                        index,
                        ) {
                      if (index <
                          playableLevels.length) {
                        final level =
                        playableLevels[index];

                        return _LevelCard(
                          level: level,
                          selected:
                          level ==
                              currentLevel,
                          onPressed: () {
                            // Send the chosen level
                            // back to the title screen.
                            Navigator.pop(
                              context,
                              level,
                            );
                          },
                        );
                      }

                      return _PlaceholderCard(
                        number: index + 1,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// PLAYABLE LEVEL
// ============================================================

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.level,
    required this.selected,
    required this.onPressed,
  });

  final GameLevel level;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? GameConstants.listenAmber
          .withValues(alpha: 0.25)
          : GameConstants.panelColor,

      borderRadius:
      BorderRadius.circular(12),

      clipBehavior: Clip.antiAlias,

      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding:
          const EdgeInsets.all(16),

          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? GameConstants.listenAmber
                  : const Color(
                0x66FFFFFF,
              ),
              width: selected ? 3 : 2,
            ),
          ),

          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Icon(
                Icons.music_note,
                size: 38,
                color: selected
                    ? GameConstants.listenAmber
                    : Colors.white,
              ),

              const SizedBox(height: 8),

              Text(
                level.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight:
                  FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                level.description,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow:
                TextOverflow.ellipsis,
                style: const TextStyle(
                  color:
                  Color(0xFFE0E0E0),
                  fontSize: 12,
                ),
              ),

              if (selected) ...[
                const SizedBox(
                  height: 10,
                ),

                const Text(
                  'SELECTED',
                  style: TextStyle(
                    color:
                    GameConstants
                        .listenAmber,
                    fontWeight:
                    FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PLACEHOLDER LEVEL
// ============================================================

class _PlaceholderCard
    extends StatelessWidget {
  const _PlaceholderCard({
    required this.number,
  });

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color:
        GameConstants.panelColor
            .withValues(alpha: 0.65),
        borderRadius:
        BorderRadius.circular(12),
        border: Border.all(
          color:
          const Color(0x44FFFFFF),
          width: 2,
        ),
      ),

      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.lock_outline,
            color: Color(0xFFAAAAAA),
            size: 34,
          ),

          const SizedBox(height: 8),

          Text(
            'LEVEL $number',
            style: const TextStyle(
              color:
              Color(0xFFAAAAAA),
              fontSize: 18,
              fontWeight:
              FontWeight.bold,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'COMING SOON',
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
              Color(0xFF888888),
              fontSize: 11,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}