import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tictactoe/constants.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  bool oTurn = true;
  List<String> displayXO = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];
  List<int> matchedIndexes = [];
  String resultDecleration = '';
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  bool winnerFound = false;
  Timer? timer;
  static const maxSeconds = 30;
  int seconds = maxSeconds;
  int attemps = 0;

  void startTimer() {
    if (timer != null) {
      timer!.cancel(); // Cancel any existing timer before starting a new one
    }
    resetTimer(); // Reset the timer to maxSeconds before starting it again
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          stopTimer(); // Stop the timer when it reaches 0
        }
      });
    });
  }

  void stopTimer() {
    timer?.cancel(); // Cancel the timer
    resetTimer(); // Reset the timer value to maxSeconds
  }

  void resetTimer() {
    setState(() {
      seconds = maxSeconds; // Reset the seconds back to maxSeconds
    });
  }

  void _resetGame() {
    setState(() {
      oScore = 0; // Reset O's score
      xScore = 0; // Reset X's score
      oTurn = true; // Set the starting turn to 'O'
      _clearBoard(); // Clear the game board
      stopTimer(); // Stop and reset the timer
      attemps = 0; // Reset attempts if you want to track it
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBachgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Player O',
                          style: TextStyle(
                              fontSize: 24,
                              color: kFontColor,
                              fontWeight: FontWeight.w800),
                        ),
                        Text(
                          oScore.toString(),
                          style: TextStyle(
                              fontSize: 24,
                              color: kFontColor,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Player X',
                          style: TextStyle(
                              fontSize: 24,
                              color: kFontColor,
                              fontWeight: FontWeight.w800),
                        ),
                        Text(
                          xScore.toString(),
                          style: TextStyle(
                              fontSize: 24,
                              color: kFontColor,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      _tapped(index);
                    },
                    child: Container(
                      margin: EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: matchedIndexes.contains(index)
                              ? kSecondryColor
                              : kPrimaryColor),
                      child: Center(
                        child: Text(
                          displayXO[index],
                          style: TextStyle(
                              fontSize: 54,
                              color: kFontColor,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      resultDecleration.toUpperCase(),
                      style: TextStyle(
                          fontSize: 24,
                          color: kFontColor,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _buildTimer(),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16)),
                        onPressed: _resetGame, // Call the reset function
                        child: Text(
                          'Reset Game',
                          style: TextStyle(fontSize: 24, color: kFontbtnColor),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _tapped(int index) {
    final isRunner = timer == null ? false : timer!.isActive;
    if (isRunner) {
      setState(() {
        if (oTurn && displayXO[index] == '') {
          displayXO[index] = 'O';
          filledBoxes++;
        } else if (!oTurn && displayXO[index] == '') {
          displayXO[index] = 'X';
          filledBoxes++;
        }
        oTurn = !oTurn;
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    // check 1st row
    if (displayXO[0] == displayXO[1] &&
        displayXO[0] == displayXO[2] &&
        displayXO[0] != '') {
      setState(() {
        resultDecleration = 'Player ' + displayXO[0] + ' Wins!';
        matchedIndexes.addAll([0, 1, 2]);
        stopTimer();
        _updateScore(displayXO[0]);
      });
    }
    // check 2nd row
    if (displayXO[3] == displayXO[4] &&
        displayXO[3] == displayXO[5] &&
        displayXO[3] != '') {
      setState(() {
        resultDecleration = 'Player ' + displayXO[3] + ' Wins!';
        matchedIndexes.addAll([3, 4, 5]);
        stopTimer();
        _updateScore(displayXO[3]);
      });
    }
    // check 3rd row
    if (displayXO[6] == displayXO[7] &&
        displayXO[6] == displayXO[8] &&
        displayXO[6] != '') {
      setState(() {
        resultDecleration = 'Player ' + displayXO[6] + ' Wins!';
        matchedIndexes.addAll([6, 7, 8]);
        stopTimer();
        _updateScore(displayXO[6]);
      });
    }
    // check 1st column
    if (displayXO[0] == displayXO[3] &&
        displayXO[0] == displayXO[6] &&
        displayXO[0] != '') {
      setState(() {
        resultDecleration = 'Player ' + displayXO[0] + ' Wins!';
        matchedIndexes.addAll([0, 3, 6]);
        stopTimer();
        _updateScore(displayXO[0]);
      });
    }
    // check 2nd column
    if (displayXO[1] == displayXO[4] &&
        displayXO[1] == displayXO[7] &&
        displayXO[1] != '') {
      setState(() {
        resultDecleration = 'Player ' + displayXO[1] + ' Wins!';
        matchedIndexes.addAll([1, 4, 7]);
        stopTimer();
        _updateScore(displayXO[1]);
      });
    }

    // check 3rd column
    if (displayXO[2] == displayXO[5] &&
        displayXO[2] == displayXO[8] &&
        displayXO[2] != '') {
      setState(() {
        resultDecleration = 'Player ' + displayXO[2] + ' Wins!';
        matchedIndexes.addAll([2, 5, 8]);
        stopTimer();
        _updateScore(displayXO[2]);
      });
    }

    // check diagonal
    if (displayXO[0] == displayXO[4] &&
        displayXO[0] == displayXO[8] &&
        displayXO[0] != '') {
      setState(() {
        resultDecleration = 'Player ' + displayXO[0] + ' Wins!';
        matchedIndexes.addAll([0, 4, 8]);
        stopTimer();
        _updateScore(displayXO[0]);
      });
    }

    // check diagonal
    if (displayXO[6] == displayXO[4] &&
        displayXO[6] == displayXO[2] &&
        displayXO[6] != '') {
      setState(() {
        resultDecleration = 'Player ' + displayXO[6] + ' Wins!';
        matchedIndexes.addAll([6, 4, 2]);
        stopTimer();
        _updateScore(displayXO[6]);
      });
    }
    if (!winnerFound && filledBoxes == 9) {
      setState(() {
        resultDecleration = 'Nobody Wins!';
        stopTimer();
      });
    }
  }

  void _updateScore(String winner) {
    if (winner == 'O') {
      oScore++;
    } else if (winner == 'X') {
      xScore++;
    }
    winnerFound = true;
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayXO[i] = '';
      }
      resultDecleration = '';
      matchedIndexes.clear(); // Clear the list to reset colors
      winnerFound = false; // Reset winner status
      filledBoxes = 0;
    });
  }

  Widget _buildTimer() {
    final isRunner = timer == null ? false : timer!.isActive;
    return isRunner
        ? SizedBox(
            width: 70.0,
            height: 70.0,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 1 - seconds / maxSeconds,
                  valueColor: AlwaysStoppedAnimation(kSecondryColor),
                  strokeWidth: 6,
                  backgroundColor: kPrimaryColor,
                ),
                Center(
                  child: Text(
                    '$seconds',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 34,
                        color: kFontColor),
                  ),
                ),
              ],
            ),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
            onPressed: () {
              startTimer();
              _clearBoard();
              attemps++;
            },
            child: Text(
              attemps == 0 ? 'Start' : 'Play Again!',
              style: TextStyle(fontSize: 24, color: kFontbtnColor),
            ));
  }
}
