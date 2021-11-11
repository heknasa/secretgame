import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goran_game/game_core.dart';
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
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            GameWidget(
              game: game,
              overlayBuilderMap: {
                QuestionBox.id: (_, GameCore gameRef) => QuestionBox(gameRef),
                PopUpDialog.id: (_, GameCore gameRef) => PopUpDialog(gameRef)
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text('ROUND TIME\n${game.roundTime.value.round()}')),
                Obx(() => Text('POINTS\n${game.points.value}')),
                GestureDetector(
                  onTap: () {},
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Icon(Icons.exit_to_app_rounded)
                  ),
                )
              ]
            )
          ],
        ),
      ),
    );
  }
}