import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screen/menu.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Hide the Android status bar and navigation bar.
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );

  runApp(
    const WormSoundsApp(),
  );
}

class WormSoundsApp extends StatelessWidget {
  const WormSoundsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Worm Sounds',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const TitleScreen(),
    );
  }
}