import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:guess_the_logo/highscore/highscore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'dart:math';
import 'dart:convert';

class RandomLogoWidget extends StatefulWidget {
  final VoidCallback updateScore;
  const RandomLogoWidget(this.updateScore, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RandomLogoWidgetState createState() => _RandomLogoWidgetState();
  
}

  Future<String> _loadAsset() async {
    return await rootBundle.loadString('assets/Logos.json');
  }


class _RandomLogoWidgetState extends State<RandomLogoWidget> {
  List<String> logoDictionary = [];
  List<String> logosSet = [];
  List<String> selectedAnswers = [];
  String selectedLogo = '';

  List<TextEditingController> textControllers = [];
  List<FocusNode> focusNodes = [];

  Future<void> _parseJson() async {
    String jsonString = await _loadAsset();
    final jsonData = json.decode(jsonString);
    final List<String> logos = List<String>.from(jsonData['Logo']);
    setState(() {
    logoDictionary.addAll(logos);
    selectRandomLogo();      
    });
    // Use the parsed jsonData as needed
  }

  @override
  void initState() {
    super.initState();
    _parseJson();
  }

  void selectRandomLogo() {
    // Dispose of previous controllers
    for (var controller in textControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }

    // Clear the lists
    textControllers.clear();
    focusNodes.clear();

    final random = Random();
    if(logosSet.isEmpty){
      logosSet = List<String>.from(logoDictionary);
    }
    int randomElement = random.nextInt(logosSet.length);
    String randomLogo = logosSet[randomElement];
    logosSet.remove(logosSet[randomElement]);
    setState(() {
      selectedLogo = randomLogo;
      // Create new text controllers for each character in the logo
      for (int i = 0; i < selectedLogo.length; i++) {
        textControllers.add(TextEditingController());
        focusNodes.add(FocusNode());
      }
    });
  }

  int score=0;
  void selectionMade(String myAnswer) {
    if(selectedLogo.toUpperCase() == myAnswer.toUpperCase()){
      score++;
      widget.updateScore();

      FocusScope.of(context).unfocus();
      for (int i = 0; i < selectedLogo.length; i++) {
        textControllers[i].clear();
        focusNodes[i].unfocus();
      }
      selectRandomLogo();
    }
    else{
      int highscore = Provider.of<HighscoreProvider>(context, listen: false).highscore;
      if(score > highscore){
        highscore = score;
      }
      Provider.of<HighscoreProvider>(context, listen: false).updateHighscore(highscore);
      FocusScope.of(context).unfocus();
      Navigator.pop(context);
    }
  }

  void _onTextChanged(int index, String value) {
    textControllers[index].text = value.toUpperCase();
    if (value.length == 1) {
      // Move focus to the next text field
      if (index < textControllers.length - 1) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      } else {
        // Reached the last text field, submit the answer
        selectionMade(textControllers.map((controller) => controller.text).join(''));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
      children: [
        const Text(
          'Randomly Selected Logo:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 160,
          height: 160,
          child: Image.asset('assets/$selectedLogo.png', fit: BoxFit.contain),
        ),
        InteractiveViewer(
          minScale: 1.0,
          maxScale: 5.0,
          scaleEnabled: true,

          child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(selectedLogo.length, (index) {
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Center(
                      child: Container(
                        width: 40, 
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: TextField(
                          controller: textControllers[index],
                          focusNode: focusNodes[index],
                          maxLength: 1,
                          textAlign: TextAlign.center,
                          onChanged: (value) => _onTextChanged(index, value),
                          onSubmitted: (value) => selectionMade(textControllers.map((controller) => controller.text).join('')),
                          decoration: const InputDecoration(
                            labelText: ' ',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        )
                      )
                  );
                },
              );
            }),
          ),
        ),
        )
      ],
    ));
  }
}

class LogoWithButtonsWidget extends StatelessWidget {
  final VoidCallback updateScore;
  const LogoWithButtonsWidget(this.updateScore, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          RandomLogoWidget(updateScore),
        ],
      ),
    );
  }
}