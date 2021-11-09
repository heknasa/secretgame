  import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:goran_game/components/world_collision.dart';
import '../helpers/direction.dart';
import 'package:flame/sprite.dart';
import 'enemy.dart';

class Player extends SpriteAnimationComponent with HasGameRef, Hitbox, Collidable {
  Player() : super(size: Vector2.all(40.0)) {
    addHitbox(HitboxRectangle());
  }
  PlayerDirection direction = PlayerDirection.noneDown;
  PlayerDirection collisionDirection = PlayerDirection.noneDown;
  bool hasCollided = false;
  final double _playerSpeed = 200.0;
  final double _animationSpeed = 0.10;
  late final SpriteAnimation _runUpAnimation;
  late final SpriteAnimation _runDownAnimation;
  late final SpriteAnimation _runLeftAnimation;
  late final SpriteAnimation _runRightAnimation;
  late final SpriteAnimation _standUpAnimation;
  late final SpriteAnimation _standDownAnimation;
  late final SpriteAnimation _standLeftAnimation;
  late final SpriteAnimation _standRightAnimation;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadAnimations().then((_) => {
      animation = _standDownAnimation
    });
  }

  @override 
  void update(double dt) {
    super.update(dt);
    movePlayer(dt);
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('player_spritesheet.png'),
      srcSize: Vector2(29.0, 32.0)
    );
    _runUpAnimation = spriteSheet.createAnimation(
      row: 2,
      stepTime: _animationSpeed,
      to: 4
    );
    _runDownAnimation = spriteSheet.createAnimation(
      row: 0,
      stepTime: _animationSpeed,
      to: 4
    );
    _runLeftAnimation = spriteSheet.createAnimation(
      row: 1,
      stepTime: _animationSpeed,
      to: 4
    );
    _runRightAnimation = spriteSheet.createAnimation(
      row: 3,
      stepTime: _animationSpeed,
      to: 4
    );
    _standUpAnimation = spriteSheet.createAnimation(
      row: 2,
      stepTime: _animationSpeed,
      to: 1
    );
    _standDownAnimation = spriteSheet.createAnimation(
      row: 0,
      stepTime: _animationSpeed,
      to: 1
    );
    _standLeftAnimation = spriteSheet.createAnimation(
      row: 1,
      stepTime: _animationSpeed,
      to: 1
    );
    _standRightAnimation = spriteSheet.createAnimation(
      row: 3,
      stepTime: _animationSpeed,
      to: 1
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Enemy || other is WorldCollision) {
      if (!hasCollided) {
        hasCollided = true;
        collisionDirection = direction;
      }
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    hasCollided = false;
  }

  bool canMovePlayerUp() {
    if (hasCollided && collisionDirection == PlayerDirection.up) {
      return false;
    }
    return true;
  }

  bool canMovePlayerDown() {
    if (hasCollided && collisionDirection == PlayerDirection.down) {
      return false;
    }
    return true;
  }

  bool canMovePlayerLeft() {
    if (hasCollided && collisionDirection == PlayerDirection.left) {
      return false;
    }
    return true;
  }

  bool canMovePlayerRight() {
    if (hasCollided && collisionDirection == PlayerDirection.right) {
      return false;
    }
    return true;
  }

  void movePlayer(double delta) {
    switch (direction) {
      case PlayerDirection.up:
        if (canMovePlayerUp()) {
          animation = _runUpAnimation;
          moveUp(delta);
        }
      break;
      case PlayerDirection.down:
        if (canMovePlayerDown()) {
          animation = _runDownAnimation;
          moveDown(delta);
        }
      break;
      case PlayerDirection.left:
        if (canMovePlayerLeft()) {
          animation = _runLeftAnimation;
          moveLeft(delta);
        }
      break;
      case PlayerDirection.right:
        if (canMovePlayerRight()) {
          animation = _runRightAnimation;
          moveRight(delta);
        }
      break;
      case PlayerDirection.noneUp:
        animation = _standUpAnimation;
        break;
      case PlayerDirection.noneDown:
        animation = _standDownAnimation;
        break;
      case PlayerDirection.noneLeft:
        animation = _standLeftAnimation;
        break;
      case PlayerDirection.noneRight:
        animation = _standRightAnimation;
        break;
    }
  }

  void moveUp(double delta) {
    position.add(Vector2(0, delta * -_playerSpeed));
  }

  void moveDown(double delta) {
    position.add(Vector2(0, delta * _playerSpeed));
  }

  void moveLeft(double delta) {
    position.add(Vector2(delta * -_playerSpeed, 0));
  }

  void moveRight(double delta) {
    position.add(Vector2(delta * _playerSpeed, 0));
  }
}