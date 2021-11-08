import 'package:flutter/material.dart';
import 'package:goran_game/game_model.dart';

class GameOver extends StatelessWidget {
  static const id = 'game over';
  final GameModel gameRef;
  const GameOver(this.gameRef, {Key? key}) : super(key: key);

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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('game over...'),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  gameRef.overlays.remove(GameOver.id);
                  gameRef.reset();
                },
                child: Text('Restart')
              )
            ],
          )
        )
      ),
    );
  }
}