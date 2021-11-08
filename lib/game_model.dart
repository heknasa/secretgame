import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';
import 'package:goran_game/components/world_collision.dart';
import 'package:goran_game/data/quiz.dart';
import 'package:goran_game/helpers/map_loader.dart';
import 'package:goran_game/widgets/game_over.dart';
import 'package:goran_game/widgets/question_box.dart';
import '../components/player.dart';
import '../helpers/direction.dart';
import 'components/enemy.dart';
import 'components/world.dart';
import 'data/quiz.dart';

class GameModel extends FlameGame with KeyboardEvents, HasCollidables {
  Player _player = Player();
  Enemy _enemy = Enemy();
  final List<Vector2> enemySpawn = [
    Vector2(400, 300),
    Vector2(400, 500),
    Vector2(400, 700),
    Vector2(400, 900),
    Vector2(400, 1100),
  ];
  final World _world = World();
  Timer countdown = Timer(10);
  bool questionShowsUp = false;
  String? selectedAnswer;
  bool hasAnswered = false;
  int points = 0;
  TextPaint textPaint = TextPaint(
    config: TextPaintConfig(color: Colors.white)
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await add(_world);
    add(_player);
    addAll(List.generate(enemySpawn.length, (i) =>
      Enemy()
        ..position = enemySpawn[i]
        // ..questionNumber = questions[i]
    ));
    addWorldCollision();
    camera.followComponent(
      _player, 
      worldBounds: Rect.fromLTRB(0, 0, _world.size.x, _world.size.y)
    );
  }

  @override
  void update(double dt) {
    countdown.update(dt);
    super.update(dt);
    if (countdown.finished && hasAnswered == false) {
      overlays.remove(QuestionBox.id);
      overlays.add(GameOver.id);
    }
  }
  
  @override
  void render(Canvas canvas) {
    textPaint.render(
      canvas,
      (countdown.limit - countdown.current).round().toString(),
      Vector2(0.0, 0.0),
    );
    textPaint.render(
      canvas,
      points.toString(),
      Vector2(size.x / 2, 0)
    );
    super.render(canvas);
  }

  void reset() {
    remove(_player);
    remove(_enemy);
    _player = Player();
    _enemy = Enemy();
    countdown = Timer(10);
    questionShowsUp = false;
    selectedAnswer = null;
    hasAnswered = false;
    points = 0;
    add(_player);
    add(_enemy);
    camera.followComponent(
      _player, 
      worldBounds: Rect.fromLTRB(0, 0, _world.size.x, _world.size.y)
    );
  }

  void addWorldCollision() async => (
    await MapLoader.readWorldCollision()
  ).forEach((rect) {
    add(WorldCollision()
      ..position = Vector2(rect.left, rect.top)
      ..width = rect.width
      ..height = rect.height);
  });

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed
  ) {
    final isKeyDown = event is RawKeyDownEvent;
    PlayerDirection? keyDirection;

    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      keyDirection = PlayerDirection.up;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      keyDirection = PlayerDirection.down;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      keyDirection = PlayerDirection.left;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      keyDirection = PlayerDirection.right;
    }

    if (isKeyDown && keyDirection != null) {
      _player.direction = keyDirection;
    } else if (_player.direction == PlayerDirection.up) {
      _player.direction = PlayerDirection.noneUp;
    } else if (_player.direction == PlayerDirection.down) {
      _player.direction = PlayerDirection.noneDown;
    } else if (_player.direction == PlayerDirection.left) {
      _player.direction = PlayerDirection.noneLeft;
    } else if (_player.direction == PlayerDirection.right) {
      _player.direction = PlayerDirection.noneRight;
    }

    if (event.logicalKey == LogicalKeyboardKey.space
      && _player.position.distanceToSquared(_enemy.position) < 12000.0
      && hasAnswered == false
    ) {
      overlays.add(QuestionBox.id);
      questionShowsUp = true;
      countdown.start();
    }

    if (questionShowsUp == true) {
      if (event.logicalKey == LogicalKeyboardKey.keyA && hasAnswered == false) {
        selectedAnswer = alphabets[0];
      } else if (event.logicalKey == LogicalKeyboardKey.keyB && hasAnswered == false) {
        selectedAnswer = alphabets[1];
      } else if (event.logicalKey == LogicalKeyboardKey.keyC && hasAnswered == false) {
        selectedAnswer = alphabets[2];
      } else if (event.logicalKey == LogicalKeyboardKey.keyD && hasAnswered == false) {
        selectedAnswer = alphabets[3];
      } 
      
      if (selectedAnswer == answers[0] && event.logicalKey == LogicalKeyboardKey.enter) {
        overlays.remove(QuestionBox.id);
        remove(_enemy);
        _player.hasCollided = false;
        countdown.stop();
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }
}