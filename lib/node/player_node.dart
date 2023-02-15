import 'package:backbone/position_node.dart';
import 'package:backbone/prelude/input/plugins/drag.dart';
import 'package:backbone/prelude/input/plugins/taps.dart';
import 'package:backbone/prelude/sprite/trait.dart';
import 'package:backbone/prelude/transform.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:rogue_shooter/components/bullet_component.dart';
import 'package:rogue_shooter/components/explosion_component.dart';
import 'package:rogue_shooter/node/enemy_node.dart';

class PlayerNode extends PositionNode with CollisionCallbacks {
  late TimerComponent bulletCreator;
  Vector2 _dragOffset = Vector2.zero();

  PlayerNode(SpriteAnimation animation)
      : super(
          transformTrait: TransformTrait()
            ..size = Vector2(50, 75)
            ..position = Vector2(100, 500)
            ..anchor = Anchor.center,
        ) {
    final trait = SpriteTrait();
    trait.animationData = animation;
    addTrait(trait);
    addTrait(
      TappableTrait(
        onTapDown: (pointer) {
          bulletCreator.timer.start();
        },
        onTapUp: (pointer) {
          bulletCreator.timer.pause();
        },
      ),
    );
    addTrait(
      DraggableTrait(
        onStart: (pointer, offset) {
          _dragOffset = offset;
          pointer.handled = true;
          if (bulletCreator.timer.isRunning() == false) {
            bulletCreator.timer.start();
          }
          return DraggablePointerPayload(this, this);
        },
        onUpdate: (pointer) {
          pointer.handled = true;
          final transform = get<TransformTrait>();
          transform.position = pointer.position;
          transform.position -= _dragOffset;
        },
        onEnd: (pointer) {
          pointer.handled = true;
          bulletCreator.timer.pause();
        },
      ),
    );
  }

  @override
  Future<void> onLoad() async {
    add(
      SpriteAnimationComponent(
        animation: get<SpriteTrait>().animationData,
      ),
    );
    add(CircleHitbox());
    add(
      bulletCreator = TimerComponent(
        period: 0.05,
        repeat: true,
        autoStart: false,
        onTick: _createBullet,
      ),
    );
  }

  final _bulletAngles = [0.5, 0.3, 0.0, -0.5, -0.3];
  void _createBullet() {
    gameRef.addAll(
      _bulletAngles.map(
        (angle) => BulletComponent(
          position: position + Vector2(0, -size.y / 2),
          angle: angle,
        ),
      ),
    );
  }

  void beginFire() {
    bulletCreator.timer.start();
  }

  void stopFire() {
    bulletCreator.timer.pause();
  }

  void takeHit() {
    gameRef.add(ExplosionComponent(position: position));
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);
    if (other is EnemyNode) {
      other.takeHit();
    }
  }
}
