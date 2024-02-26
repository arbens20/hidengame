import 'dart:math';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart'; // Import de la bibliothèque pour utiliser SystemNavigator

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<String> words = [
    'Lub - Fondateur de code9class',
    'Python - Un langage de programmation',
    'Dimanche - Un jour de la semaine".',
    'ariel - Premier Ministre defacto du pays".',
  ];
  late String chosenWord;
  late String displayedWord;
  final Set<String> guessedLetters = {};
  int chances = 5;

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    int index = Random().nextInt(words.length);
    chosenWord = words[index].split(' - ').first.toLowerCase();
    displayedWord = '*' * chosenWord.length;
    guessedLetters.clear();
    chances = 5;
  }

  void guessLetter(String letter) {
    setState(() {
      if (chosenWord.contains(letter)) {
        displayedWord = displayedWord.split('').asMap().entries.map((entry) {
          int index = entry.key;
          String char = entry.value;
          return chosenWord[index] == letter ? letter : char;
        }).join();
      } else {
        chances--;
      }
      guessedLetters.add(letter);
      checkGameStatus();
    });
  }

  void checkGameStatus() {
    if (displayedWord == chosenWord || chances == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            startNewGame,
            chances,
            displayedWord == chosenWord,
            words.firstWhere((word) => word.split(' - ').first.toLowerCase() == chosenWord.toLowerCase()).split(' - ').last,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mots Cache'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Chances: $chances',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Jwenn mo ki kache an',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              displayedWord.toUpperCase(),
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(height: 10),
            Text(
              words.firstWhere((word) => word.split(' - ').first.toLowerCase() == chosenWord.toLowerCase()).split(' - ').last,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
                itemCount: 26,
                itemBuilder: (context, index) {
                  String letter = String.fromCharCode('a'.codeUnitAt(0) + index);
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ElevatedButton(
                      onPressed: guessedLetters.contains(letter) ? null : () => guessLetter(letter),
                      child: Text(letter.toUpperCase()),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NameGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Liste des noms
    final List<String> names = [
      '               ',
      'DEVELOPPER PAR:',
      '               ',
      'Lynne-Flore Simy',
      'Parilus Mathieu',
      'Vital Arbens',
      'Orelien Nageline',
      'MaxWiskennExalent',
      'Saintil Ralph Jacky'
    ];

    return Column(
      children: names.map((name) => Text(name)).toList(),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final Function() startNewGame;
  final int chancesRemaining;
  final bool isWinner;
  final String hint;

  ResultScreen(this.startNewGame, this.chancesRemaining, this.isWinner, this.hint);

  @override
  Widget build(BuildContext context) {
    String resultMessage = isWinner ? 'Ou Genyen!' : 'Ou Pedi';
    return Scaffold(
      appBar: AppBar(
        title: Text(resultMessage),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Remaining Chances: $chancesRemaining',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Hint: $hint',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    startNewGame();
                    Navigator.pop(context); // Fermer l'écran des résultats
                  },
                  child: Text('kite'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(),
                      ),
                    );
                  },
                  child: Text('Jwe Anko'),
                ),
              ],
            ),
            SizedBox(height: 20),
            NameGrid(), // Ajout du widget NameGrid pour afficher les noms des développeurs
          ],
        ),
      ),
    );
  }
}
