import 'dart:math';

import 'package:flutter/material.dart';
import 'package:goran_game/data/quiz.dart';
import 'package:goran_game/widgets/question_box.dart';

import '../game_core.dart';
import 'answer_pad.dart';

class QnAPad extends StatelessWidget {
  static const id = 'qna pad';

  const QnAPad({
    Key? key,
    required this.gameRef,
    required this.alignment,
    required this.width,
  }) : super(key: key);

  final GameCore gameRef;
  final Alignment alignment;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 180.0),
        child: Material(
          type: MaterialType.transparency,
          child: Ink(
            width: width * 0.15,
            height: width * 0.1,
            decoration:  BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(25.0)
            ),
            child: InkWell(    
              onTap: () {
                for (var i = 0; i < gameRef.enemies.length; i++) {
                  if (gameRef.player.position.distanceToSquared(gameRef.enemies[i].position) < 12000.0
                    && gameRef.questionShowsUp == false
                  ) {
                    gameRef.overlays.remove(QnAPad.id);
                    gameRef.index = i;
                    gameRef.random = Random().nextInt(questions.length);
                    shuffleChoices(gameRef.random!);
                    gameRef.overlays.add(QuestionBox.id);
                    gameRef.overlays.add(AnswerPad.id);
                    gameRef.questionShowsUp = true;
                    gameRef.quizCountdown.start();
                  }
                }
              },
              child: Center(
                child: Icon(
                  Icons.question_answer_rounded,
                  size: width * 0.05,
                  color: Colors.black.withOpacity(0.75)
                )
              ),
              borderRadius: BorderRadius.circular(25.0)
            )
            
          ),
        ),
      ),
    );
  }
}