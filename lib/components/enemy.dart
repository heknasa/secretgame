import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';

class Enemy extends SpriteAnimationComponent with HasGameRef, Hitbox, Collidable {
  Enemy(this.enemyNumber) : super(size: Vector2.all(50.0)) {
    addHitbox(HitboxRectangle());
  }
  final int? enemyNumber;
  final double _animationSpeed = 0.10;
  late final SpriteAnimation _standUpAnimation;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadAnimations().then((_) => {
      animation = _standUpAnimation
    });
  }

  @override 
  void update(double dt) {
    super.update(dt);
    //TODO update meledak
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('enemy.png'),
      srcSize: Vector2(24.0, 24.0)
    );
    _standUpAnimation = spriteSheet.createAnimation(
      row: 1,
      stepTime: _animationSpeed,
      to: 4
    );
  }
}