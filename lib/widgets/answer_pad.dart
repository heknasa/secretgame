import 'package:flutter/material.dart';
import 'package:goran_game/helpers/dpad.dart';

import '../game_core.dart';
import 'package:goran_game/data/quiz.dart';

import 'popup_dialog.dart';
import 'question_box.dart';

class AnswerPad extends StatelessWidget {
  static const id = 'answer pad';

  AnswerPad({
    Key? key,
    required this.gameRef,
    required this.alignment,
    required this.width,
    required this.height
  }) : super(key: key);

  final GameCore gameRef;
  final Alignment alignment;
  final double width;
  final double height;
  final Map<String, int> answerMap = {'A': 0, 'B': 1, 'C': 2, 'D': 3};

  void answeringQuestions(String answerAlpha) {
    gameRef.selectedAnswer ??= choices[gameRef.random!][answerMap[answerAlpha]!];
    if (gameRef.hasAnswered == false && gameRef.selectedAnswer == answers[gameRef.random!]) {
      gameRef.quizCountdown.pause();
      gameRef.points++;
      gameRef.hasAnswered = true;
    } else if (gameRef.hasAnswered == false && gameRef.selectedAnswer != answers[gameRef.random!]) {
      gameRef.popUpTitle = 'game over...';
      gameRef.roundCountdown.pause();
      gameRef.quizCountdown.pause();
      gameRef.overlays.remove(QuestionBox.id);
      gameRef.overlays.remove(AnswerPad.id);
      gameRef.overlays.remove(DPad.id);
      gameRef.overlays.add(PopUpDialog.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 30.0),
        height: height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlphabetPad(
              button: 'A',
              onTap: () => answeringQuestions('A'),
              width: width
            ),
            SizedBox(height: height * 0.02),
            AlphabetPad(
              button: 'B',
              onTap: () => answeringQuestions('B'),
              width: width
            ),
            SizedBox(height: height * 0.02),
            AlphabetPad(
              button: 'C',
              onTap: () => answeringQuestions('C'),
              width: width
            ),
            SizedBox(height: height * 0.02),
            AlphabetPad(
              button: 'D',
              onTap: () => answeringQuestions('D'),
              width: width
            ),
          ]
        ),
      ),
    );
  }
}

class AlphabetPad extends StatelessWidget {
  const AlphabetPad({
    Key? key,    
    required this.button,
    required this.onTap,
    required this.width
  }) : super(key: key);

  final double width;
  final VoidCallback onTap;
  final String button;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Ink(
        width: width * 0.1,
        height: width * 0.1,
        decoration:  BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15.0)
        ),
        child: InkWell(    
          onTap: onTap,
          child: Center(
            child: Text(
              button,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.75)
              )
            )
          ),
          borderRadius: BorderRadius.circular(10.0)
        )
      ),
    );
  }
}