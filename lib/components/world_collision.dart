import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

class WorldCollision extends PositionComponent with HasGameRef, Hitbox, Collidable {
  WorldCollision() {
    addHitbox(HitboxRectangle());
  }
}