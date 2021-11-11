import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';
import 'package:goran_game/components/world_collision.dart';
import 'package:goran_game/data/quiz.dart';
import 'package:goran_game/helpers/map_loader.dart';
import 'package:goran_game/widgets/popup_dialog.dart';
import 'package:goran_game/widgets/question_box.dart';
import '../components/player.dart';
import '../helpers/direction.dart';
import 'components/enemy.dart';
import 'components/world.dart';
import 'data/quiz.dart';
import 'package:get/get.dart';

class GameCore extends FlameGame with KeyboardEvents, HasCollidables {
  final Player _player = Player();
  List<Enemy> enemies = [];
  List<Enemy> diedEnemies = [];
  List<String> passedQuestions = [];
  List<List<String>> passedChoices = [];
  List<String> passedAnswers = [];
  int? index;
  int? random;
  List<Vector2> enemySpawn = [
    Vector2(400, 300),
    Vector2(400, 500),
    Vector2(400, 700),
    Vector2(400, 900),
    Vector2(400, 1100),
  ];
  final World _world = World();
  bool questionShowsUp = false;
  String? selectedAnswer;
  bool hasAnswered = false;
  Timer roundCountdown = Timer(10.0 * 5 * 1.5);
  Timer quizCountdown = Timer(10.0);
  String? popUpTitle;
  var roundTime = Rx<double>(10.0 * 5 * 1.5);
  var quizTime = Rx<double>(10.0);
  var points = 0.obs;

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
    popUpTitle = 'Ready?';  
    overlays.add(PopUpDialog.id);
  }

  @override
  void update(double dt) {    
    if (roundCountdown.isRunning()) {
      roundTime -= dt;
    } else if (roundCountdown.finished) {
      roundCountdown.stop();
    }
    if (quizCountdown.isRunning()) {
      quizTime -= dt;
    } else if (quizCountdown.finished) {
      quizCountdown.stop();
    }
    roundCountdown.update(dt);
    quizCountdown.update(dt);          
    super.update(dt);
    if ((roundCountdown.finished || quizCountdown.finished) && hasAnswered == false) {
      popUpTitle = 'game over...';
      roundCountdown.pause();
      overlays.remove(QuestionBox.id);
      overlays.add(PopUpDialog.id);
    }
    if (enemies.isEmpty) {
      popUpTitle = 'YOU WIN!!\nPlay Again?';
      roundCountdown.pause();
      overlays.add(PopUpDialog.id);
    }
  }

  void reset() {
    remove(_player);
    add(_player..position = size * 0.5);
    enemies.addAll(diedEnemies);
    addAll(diedEnemies);
    questions.addAll(passedQuestions);
    choices.addAll(passedChoices);
    answers.addAll(passedAnswers);
    camera.followComponent(
      _player, 
      worldBounds: Rect.fromLTRB(0, 0, _world.size.x, _world.size.y)
    );
    roundTime.value = 10.0 * 5 * 1.5;
    roundCountdown.start();
    quizTime.value = 10.0;
    points.value = 0;
    questionShowsUp = false;
    hasAnswered = false;
    selectedAnswer = null;
    index = null;
    random = null;
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
        && questionShowsUp == false
      ) {
        index = i;
        random = Random().nextInt(questions.length);
        shuffleChoices(random!);
        overlays.add(QuestionBox.id);
        questionShowsUp = true;
        quizCountdown.start();
      }
      if (questionShowsUp == true) {
        if (event.logicalKey == LogicalKeyboardKey.keyA && hasAnswered == false) {
          selectedAnswer = choices[random!][0];
        } else if (event.logicalKey == LogicalKeyboardKey.keyB && hasAnswered == false) {
          selectedAnswer = choices[random!][1];
        } else if (event.logicalKey == LogicalKeyboardKey.keyC && hasAnswered == false) {
          selectedAnswer = choices[random!][2];
        } else if (event.logicalKey == LogicalKeyboardKey.keyD && hasAnswered == false) {
          selectedAnswer = choices[random!][3];
        } 
        if (hasAnswered == false && selectedAnswer == answers[random!]) {
          quizCountdown.pause();
          points++;
          hasAnswered = true;
        } else if (
          hasAnswered == false 
          && selectedAnswer != answers[random!]
          && (selectedAnswer == choices[random!][0]
          || selectedAnswer == choices[random!][1]
          || selectedAnswer == choices[random!][2]
          || selectedAnswer == choices[random!][3])
        ) {
          popUpTitle = 'game over...';
          roundCountdown.pause();
          quizCountdown.pause();
          overlays.remove(QuestionBox.id);
          overlays.add(PopUpDialog.id);
          hasAnswered = true;
        }        
        if (selectedAnswer == answers[random!] && event.logicalKey == LogicalKeyboardKey.enter) {
          quizCountdown.stop();
          overlays.remove(QuestionBox.id);
          diedEnemies.add(enemies[index!]);
          passedQuestions.add(questions[random!]);
          passedChoices.add(choices[random!]);
          passedAnswers.add(answers[random!]);
          remove(enemies[index!]);
          enemies.removeAt(index!);
          questions.removeAt(random!);
          choices.removeAt(random!);
          answers.removeAt(random!);
          quizTime = Rx<double>(10.0);
          _player.hasCollided = false;
          questionShowsUp = false;
          hasAnswered = false;
          selectedAnswer = null;
          index = null;
          random = null;
        }
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }
}