import 'package:flutter/material.dart';
import 'package:guess_the_logo/pages/modules/game_logic.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  void updateScore() {
    setState(() {
      score++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:
        Column(
          children: [
            Center(
              child: LogoWithButtonsWidget(updateScore),
            ),
            Center(
              child: Text('Your score: ${score.toString()}'),
            ),
          ],
        ),
    );
  }
}
