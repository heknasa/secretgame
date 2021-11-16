import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:goran_game/game_core.dart';
import 'package:goran_game/helpers/dpad.dart';
import 'package:goran_game/widgets/qnapad.dart';

class PopUpDialog extends StatelessWidget {
  static const id = 'pop up dialog';
  final GameCore gameRef;
  const PopUpDialog(this.gameRef, {Key? key}) : super(key: key);

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
              Text(gameRef.popUpTitle!),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (gameRef.popUpTitle == 'Ready?') {
                    var platform = Theme.of(context).platform;
                    gameRef.overlays.remove(PopUpDialog.id);
                    if (platform == TargetPlatform.android
                      || platform == TargetPlatform.iOS
                      || platform == TargetPlatform.windows
                    ) {
                      gameRef.overlays.add(DPad.id);
                      gameRef.overlays.add(QnAPad.id);
                      gameRef.gamerIsOnMobile = true;
                    }
                    else if (
                      // platform == TargetPlatform.windows
                      platform == TargetPlatform.macOS
                      || platform == TargetPlatform.linux
                    ) {
                      gameRef.gamerIsOnPC = true;
                    }
                    gameRef.overlays.remove(PopUpDialog.id);                                        
                    gameRef.roundCountdown.start();
                  } else if (
                    gameRef.popUpTitle == 'game over...'
                    || gameRef.popUpTitle == 'YOU WIN!!\nPlay Again?'
                  ) {                       
                    gameRef.reset();
                  }
                },
                child: Text('YES')
              )
            ],
          )
        )
      ),
    );
  }
}