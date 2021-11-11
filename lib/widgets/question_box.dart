import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goran_game/data/quiz.dart';
import '../game_core.dart';

class QuestionBox extends StatelessWidget {
  static const id = 'question';
  final GameCore gameRef;
  const QuestionBox(this.gameRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        padding: EdgeInsets.all(20.0),
        width: 200.0,
        height: 240.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              child: Text('Pertanyaan #' + (gameRef.enemies[gameRef.index!].enemyNumber! + 1).toString()),
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
            )
          ],
        ),
      ),
    );
  }
}