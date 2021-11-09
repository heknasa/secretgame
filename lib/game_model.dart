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
  final Player _player = Player();
  List<Enemy> enemies = [];
  List<Enemy> diedEnemies = [];
  int? index;
  List<Vector2> enemySpawn = [
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
    add(_player..position = size * 0.5);
    for (var i = 0; i < enemySpawn.length; i++) {
      enemies.add(Enemy(i)..position = enemySpawn[i]);
    }
    addAll(enemies);
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
    add(_player..position = size * 0.5);
    enemies.addAll(diedEnemies);
    addAll(diedEnemies);
    camera.followComponent(
      _player, 
      worldBounds: Rect.fromLTRB(0, 0, _world.size.x, _world.size.y)
    );
    countdown = Timer(10);
    points = 0;
    questionShowsUp = false;
    hasAnswered = false;
    selectedAnswer = null;
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

    for (var i = 0; i < enemies.length; i++) {
      if (event.logicalKey == LogicalKeyboardKey.space
        && _player.position.distanceToSquared(enemies[i].position) < 12000.0
        && hasAnswered == false
      ) {
        index = i;
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
        if (hasAnswered == false && selectedAnswer == answers[index!]) {
          countdown.pause();
          points++;
          hasAnswered = true;
        } else if (
          hasAnswered == false 
          && selectedAnswer != answers[index!]
          && (selectedAnswer == alphabets[0]
          || selectedAnswer == alphabets[1]
          || selectedAnswer == alphabets[2]
          || selectedAnswer == alphabets[3])
        ) {
          countdown.pause();
          overlays.remove(QuestionBox.id);
          overlays.add(GameOver.id);
          hasAnswered = true;
        }        
        if (selectedAnswer == answers[index!] && event.logicalKey == LogicalKeyboardKey.enter) {
          countdown.stop();
          overlays.remove(QuestionBox.id);
          diedEnemies.add(enemies[index!]);
          remove(enemies[index!]);
          enemies.removeAt(index!);
          _player.hasCollided = false;
          questionShowsUp = false;
          hasAnswered = false;
          selectedAnswer = null;
          index = null;
        }
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }
}