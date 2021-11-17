import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../game_core.dart';

class Hud extends StatelessWidget {
  const Hud({
    Key? key,
    required this.game,
    required this.alignment,
  }) : super(key: key);

  final GameCore game;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;
    return Align(
      alignment: alignment,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [               
              if (platform == TargetPlatform.windows
                || platform == TargetPlatform.macOS
                || platform == TargetPlatform.linux
              )...[
                Tooltip(
                  message: 'ARROW-UP: Up\nARROW-DOWN: Down\nARROW-LEFT: Left\nARROW-RIGHT: Right\nSPACE: Ask\nA: Answer A\nB: Answer B\nC: Answer C\nD: Answer D',
                  child: Icon(Icons.help_outlined),
                )
              ],
              Obx(() => Text('ROUND TIME\n${game.roundTime.value.round()}')),
            ],
          ),
          Obx(() => Text('POINTS\n${game.points.value}')),
          GestureDetector(
            onTap: () {},
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Icon(Icons.exit_to_app_rounded)
            ),
          )
        ]
      ),
    );
  }
}