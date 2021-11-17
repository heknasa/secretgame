import 'package:flutter/material.dart';
import 'package:goran_game/helpers/direction.dart';

import '../game_core.dart';

class DPad extends StatefulWidget {
  static const id = 'd pad';

  const DPad({
    Key? key,
    required this.gameRef,
    required this.alignment,
    required this.width,
  }) : super(key: key);

  final GameCore gameRef;
  final Alignment alignment;
  final double width;

  @override
  State<DPad> createState() => _DPadState();
}

class _DPadState extends State<DPad> {  
  bool upIsClicked = false;
  bool leftIsClicked = false;
  bool rightIsClicked = false;
  bool downIsClicked = false;
  @override
  Widget build(BuildContext context) {    
    return Align(
      alignment: widget.alignment,
      child: Container(
        margin: const EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 60.0),
        height: widget.width * 0.3,
        width: widget.width * 0.3,
        child: Column(
          children: [
            GestureDetector(
              onTapDown: (event) {
                widget.gameRef.player.direction = PlayerDirection.up;
                setState(() {
                  upIsClicked = true;
                });
              },
              onTapUp: (event) {
                widget.gameRef.player.direction = PlayerDirection.noneUp;
                setState(() {
                  upIsClicked = false;
                });
              },
              child: Container(
                width: widget.width * 0.1,
                height: widget.width * 0.1,
                child: Icon(
                  Icons.arrow_drop_up_rounded,
                  size: widget.width * 0.1,
                  color: upIsClicked == false
                  ? Colors.black.withOpacity(0.75)
                  : Colors.black.withOpacity(0.6) 
                ),
                decoration: BoxDecoration(
                  color: upIsClicked == false
                  ? Colors.white.withOpacity(0.5)
                  : Colors.white.withOpacity(0.4),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)
                  )
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTapDown: (event) {
                    widget.gameRef.player.direction = PlayerDirection.left;
                    setState(() {
                      leftIsClicked = true;
                    });
                  },
                  onTapUp: (event) {
                    widget.gameRef.player.direction = PlayerDirection.noneLeft;
                    setState(() {
                      leftIsClicked = false;
                    });
                  },
                  child: Container(
                    width: widget.width * 0.1,
                    height: widget.width * 0.1,
                    child: Icon(
                      Icons.arrow_left_rounded,
                      size: widget.width * 0.1,
                      color: leftIsClicked == false
                      ? Colors.black.withOpacity(0.75)
                      : Colors.black.withOpacity(0.6) 
                    ),
                    decoration: BoxDecoration(
                      color: leftIsClicked == false
                      ? Colors.white.withOpacity(0.5)
                      : Colors.white.withOpacity(0.4),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0)
                      )
                    ),
                  ),
                ),
                Container(
                  color: Colors.white.withOpacity(0.5),
                  width: widget.width * 0.1,
                  height: widget.width * 0.1,
                  child: Icon(
                    Icons.clear_rounded,
                    size: widget.width * 0.05,
                    color: Colors.black.withOpacity(0.75),
                  )
                ),
                GestureDetector(
                  onTapDown: (event) {
                    widget.gameRef.player.direction = PlayerDirection.right;
                    setState(() {
                      rightIsClicked = true;
                    });
                  },
                  onTapUp: (event) {
                    widget.gameRef.player.direction = PlayerDirection.noneRight;
                    setState(() {
                      rightIsClicked = false;
                    });
                  },
                  child: Container(
                    width: widget.width * 0.1,
                    height: widget.width * 0.1,
                    child: Icon(
                      Icons.arrow_right_rounded,
                      size: widget.width * 0.1,
                      color: rightIsClicked == false
                      ? Colors.black.withOpacity(0.75)
                      : Colors.black.withOpacity(0.6) 
                    ),
                    decoration: BoxDecoration(
                      color: rightIsClicked == false
                      ? Colors.white.withOpacity(0.5)
                      : Colors.white.withOpacity(0.4),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0)
                      )
                    ),
                  ),
                ),
              ]
            ),
            GestureDetector(
              onTapDown: (event) {
                widget.gameRef.player.direction = PlayerDirection.down;
                setState(() {
                  downIsClicked = true;
                });
              },
              onTapUp: (event) {
                widget.gameRef.player.direction = PlayerDirection.noneDown;
                setState(() {
                  downIsClicked = false;
                });
              },
              child: Container(
                width: widget.width * 0.1,
                height: widget.width * 0.1,
                child: Icon(
                  Icons.arrow_drop_down_rounded,
                  size: widget.width * 0.1,
                  color: downIsClicked == false
                  ? Colors.black.withOpacity(0.75)
                  : Colors.black.withOpacity(0.6) 
                ),
                decoration: BoxDecoration(
                  color: downIsClicked == false
                  ? Colors.white.withOpacity(0.5)
                  : Colors.white.withOpacity(0.4),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)
                  )
                ),
              ),
            ),
          ]
        ),
      ),
    );     
  }
}