import "package:flutter/material.dart";
import "package:provider/provider.dart";

import './modules/share.dart';
import "../highscore/highscore.dart";
import "./game.dart";


// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    int highscore = Provider.of<HighscoreProvider>(context).highscore;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.deepOrange,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: Center(
                child: Image.asset('assets/Logo.png'),
              ),
            ),
            Title(color: Colors.black, child: const Text("GUESS THE LOGO!", style: TextStyle(fontSize: 36.0,))),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                  child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => const GameScreen()));
                },
                icon: const Icon(Icons.play_arrow, size: 18),
                label: const Text("PLAY"),
              )),
            ),
            Center(
              child: Text(
                'Highscore: $highscore',
                textAlign: TextAlign.center,
              ),
            ),
            const Center(
              child: ShareButton(),
              )
          ],
        ));
  }
}
