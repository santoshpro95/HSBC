import 'package:flutter/material.dart';
import 'package:hsbc/features/avatar_tts/avatar_tts_screen.dart';

// region App
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  // region Build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      routes: {'/initial': (context) => const AvatarTTSScreen()},
      initialRoute: '/initial',
    );
  }
}
// endregion
