import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './pages/main_screen.dart';
import 'highscore/highscore.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => HighscoreProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guess The Logo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Guess The Logo',),
    );
  }
}