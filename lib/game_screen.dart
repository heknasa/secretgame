import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:goran_game/game_model.dart';
import 'package:goran_game/widgets/game_over.dart';
import 'package:goran_game/widgets/question_box.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({ Key? key }) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameModel game = GameModel();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            GameWidget(
              game: game,
              overlayBuilderMap: {
                QuestionBox.id: (_, GameModel gameRef) => QuestionBox(gameRef),
                GameOver.id: (_, GameModel gameRef) => GameOver(gameRef)
              },
            ),
          ],
        ),
      ),
    );
  }
}