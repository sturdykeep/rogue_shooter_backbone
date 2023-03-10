import 'package:backbone/entity.dart';
import 'package:backbone/prelude/render/sprite.dart';
import 'package:backbone/prelude/render/trait.dart';
import 'package:backbone/prelude/transform.dart';
import 'package:backbone/realm.dart';
import 'package:flame/components.dart';
import 'package:rogue_shooter/trait/clean_up_trait.dart';
import 'package:rogue_shooter/trait/collision_trait.dart';
import 'package:rogue_shooter/trait/move_trait.dart';

class BulletEntity extends Entity /*with CollisionCallbacks*/ {
  static const speed = 500.0;
  late final Vector2 velocity;
  final Vector2 deltaPosition = Vector2.zero();

  BulletEntity({
    required Realm realm,
    required Vector2 position,
    required double angle,
    required SpriteAnimation bullet,
  }) : super(realm) {
    final transform = Transform()
      ..size = Vector2(10, 20)
      ..rotation = angle
      ..position = position;
    add(transform);
    add(CollisionTrait(5));
    add(
      Renderable(
        visual: SpriteAnimationVisual(
          animation: bullet.clone(),
        ),
      ),
    );
    add(
      MoveTrait(
        Vector2(0, -1)
          ..rotate(angle)
          ..scale(speed),
      ),
    );
    add(CleanUpTrait());
  }

/*

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);
    if (other is EnemyNode) {
      other.takeHit();
      removeFromParent();
    }
  }
  */
}
