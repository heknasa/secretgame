import 'package:flutter/material.dart';
import 'package:goran_game/data/quiz.dart';
import '../game_model.dart';

class QuestionBox extends StatelessWidget {
  static const id = 'question';
  final GameModel gameRef;
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
        height: 200.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text('Pertanyaan #1'),
            ),
            SizedBox(height: 20.0),
            Text(questions[0]),
            SizedBox(height: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < 4; i++)
                  Text(alphabets[i] + '. ' + choices[0][i])
              ]
            )
          ],
        ),
      ),
    );
  }
}