import 'package:flutter/material.dart';
import 'package:goran_game/helpers/direction.dart';

import '../game_core.dart';

class DPad extends StatelessWidget {
  static const id = 'd pad';

  const DPad({
    Key? key,
    required this.game,
    required this.alignment,
    required this.width,
  }) : super(key: key);

  final GameCore game;
  final Alignment alignment;
  final double width;

  @override
  Widget build(BuildContext context) {
    PlayerDirection? keyDirection;
    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 60.0),
        height: width * 0.3,
        width: width * 0.3,
        child: Column(
          children: [
            Material(
              type: MaterialType.transparency,
              child: Ink(
                width: width * 0.1,
                height: width * 0.1,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)
                  )
                ),
                child: InkWell(    
                  onTap: () {
                  },
                  child: Icon(
                    Icons.arrow_drop_up_rounded,
                    size: width * 0.1,
                    color: Colors.black.withOpacity(0.75),
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)
                  )
                )
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                  type: MaterialType.transparency,
                  child: Ink(
                    width: width * 0.1,
                    height: width * 0.1,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0)
                      )
                    ),
                    child: InkWell(    
                      onTap: () {},
                      child: Icon(
                        Icons.arrow_left_rounded,
                        size: width * 0.1,
                        color: Colors.black.withOpacity(0.75),
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0)
                      )
                    )
                  ),
                ),
                Container(
                  color: Colors.white.withOpacity(0.5),
                  width: width * 0.1,
                  height: width * 0.1,
                  child: Icon(
                    Icons.clear_rounded,
                    size: width * 0.05,
                    color: Colors.black.withOpacity(0.75),
                  )
                ),
                Material(
                  type: MaterialType.transparency,
                  child: Ink(
                    width: width * 0.1,
                    height: width * 0.1,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0)
                      )
                    ),
                    child: InkWell(    
                      onTap: () {},
                      child: Icon(
                        Icons.arrow_right_rounded,
                        size: width * 0.1,
                        color: Colors.black.withOpacity(0.75),
                      ),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0)
                      )
                    )
                  ),
                ),
              ]
            ),
            Material(
              type: MaterialType.transparency,
              child: Ink(
                width: width * 0.1,
                height: width * 0.1,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)
                  )
                ),
                child: InkWell(    
                  onTap: () {},
                  child: Icon(
                    Icons.arrow_drop_down_rounded,
                    size: width * 0.1,
                    color: Colors.black.withOpacity(0.75),
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)
                  )
                )
              ),
            ),
          ]
        ),
      ),
    );     
  }
}