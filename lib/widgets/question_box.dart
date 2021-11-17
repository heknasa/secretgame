import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goran_game/data/quiz.dart';
import '../game_core.dart';
import 'answer_pad.dart';
import 'qnapad.dart';

class QuestionBox extends StatelessWidget {
  static const id = 'question';
  final GameCore gameRef;
  const QuestionBox(this.gameRef, {Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        padding: EdgeInsets.all(20.0),
        width: 200.0,
        height: 300.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text('TIME')
            ),
            SizedBox(height: 5.0),
            Center(
              child: Obx(() => Text('${gameRef.quizTime.value.round()}'))
            ),
            SizedBox(height: 10.0),
            Center(
              child: Text('Pertanyaan #${(gameRef.points.value + 1)}')
            ),
            SizedBox(height: 20.0),
            Text(questions[gameRef.random!]),
            SizedBox(height: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < alphabets.length; i++)
                  Text(alphabets[i] + '. ' + choices[gameRef.random!][i])
              ]
            ),
            SizedBox(height: 10.0),
            Obx(() => Center(
              child: (gameRef.answerIsCorrect.value == true
                && (platform == TargetPlatform.windows
                || platform == TargetPlatform.macOS
                || platform == TargetPlatform.linux)
              )
              ? Text('press ENTER to continue')           
              : (gameRef.answerIsCorrect.value == true
                && (platform == TargetPlatform.android
                || platform == TargetPlatform.iOS)
              )
              ? ElevatedButton(
                child: Text('Next'),
                onPressed: () {
                  gameRef.quizCountdown.stop();
                  gameRef.overlays.remove(QuestionBox.id);
                  gameRef.overlays.remove(AnswerPad.id);
                  gameRef.diedEnemies.add(gameRef.enemies[gameRef.index!]);
                  gameRef.passedQuestions.add(questions[gameRef.random!]);
                  gameRef.passedChoices.add(choices[gameRef.random!]);
                  gameRef.passedAnswers.add(answers[gameRef.random!]);
                  gameRef.remove(gameRef.enemies[gameRef.index!]);
                  gameRef.enemies.removeAt(gameRef.index!);
                  questions.removeAt(gameRef.random!);
                  choices.removeAt(gameRef.random!);
                  answers.removeAt(gameRef.random!);
                  gameRef.quizTime = Rx<double>(10.0);
                  gameRef.player.hasCollided = false;
                  gameRef.questionShowsUp = false;
                  gameRef.hasAnswered = false;
                  gameRef.answerIsCorrect.value = false;
                  gameRef.selectedAnswer = null;
                  gameRef.index = null;
                  gameRef.random = null;
                  gameRef.overlays.add(QnAPad.id);
                },                  
              )
              : SizedBox()
            ))          
          ],
        ),
      ),
    );
  }
}