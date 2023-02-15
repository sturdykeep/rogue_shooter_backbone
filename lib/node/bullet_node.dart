import 'package:backbone/position_node.dart';
import 'package:backbone/prelude/sprite/trait.dart';
import 'package:backbone/prelude/transform.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:rogue_shooter/node/enemy_node.dart';
import 'package:rogue_shooter/trait/clean_up_trait.dart';
import 'package:rogue_shooter/trait/move_trait.dart';

class BulletNode extends PositionNode with CollisionCallbacks {
  static const speed = 500.0;
  late final Vector2 velocity;
  final Vector2 deltaPosition = Vector2.zero();

  BulletNode({
    required Vector2 position,
    required double angle,
    required SpriteAnimation bullet,
  }) : super(
          transformTrait: TransformTrait()
            ..size = Vector2(10, 20)
            ..rotation = angle
            ..position = position,
        ) {
    final sprite = SpriteTrait();
    sprite.animationData = bullet;
    addTrait(sprite);
    addTrait(
      MoveTrait(
        Vector2(0, -1)
          ..rotate(angle)
          ..scale(speed),
      ),
    );
    addTrait(CleanUpTrait());
  }

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
    add(
      SpriteAnimationComponent(
        animation: get<SpriteTrait>().animationData,
      ),
    );
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);
    if (other is EnemyNode) {
      other.takeHit();
      removeFromParent();
    }
  }
}
