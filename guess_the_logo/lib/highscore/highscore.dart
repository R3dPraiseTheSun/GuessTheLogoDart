import 'package:flutter/material.dart';

class HighscoreProvider with ChangeNotifier {
  int _highscore = 0;

  int get highscore => _highscore;

  void updateHighscore(int newHighscore) {
    _highscore = newHighscore;
    notifyListeners();
  }
}
