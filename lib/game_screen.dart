import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:goran_game/game_core.dart';
import 'package:goran_game/helpers/dpad.dart';
import 'package:goran_game/widgets/qnapad.dart';
import 'package:goran_game/widgets/answer_pad.dart';
import 'helpers/hud.dart';
import 'widgets/popup_dialog.dart';
import 'widgets/question_box.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({ Key? key }) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameCore game = GameCore();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(
            game: game,
            overlayBuilderMap: {
              DPad.id: (_, GameCore gameRef) => DPad(gameRef: game, alignment: Alignment.bottomLeft, width: width),
              QnAPad.id: (_, GameCore gameRef) => QnAPad(gameRef: game, alignment: Alignment.bottomRight, width: width),
              AnswerPad.id: (_, GameCore gameRef) => AnswerPad(gameRef: gameRef, alignment: Alignment.bottomRight, width: width, height: height),
              QuestionBox.id: (_, GameCore gameRef) => QuestionBox(gameRef),
              PopUpDialog.id: (_, GameCore gameRef) => PopUpDialog(gameRef),
            },
          ),
          Hud(game: game, alignment: Alignment.topCenter),
        ],
      ),
    );
  }
}