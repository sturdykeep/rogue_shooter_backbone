import 'package:backbone/position_node.dart';
import 'package:backbone/prelude/input/plugins/drag.dart';
import 'package:backbone/prelude/input/plugins/taps.dart';
import 'package:backbone/prelude/sprite/trait.dart';
import 'package:backbone/prelude/transform.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:rogue_shooter/components/explosion_component.dart';
import 'package:rogue_shooter/node/bullet_node.dart';
import 'package:rogue_shooter/node/enemy_node.dart';
import 'package:rogue_shooter/resources/sprite_storage.dart';
import 'package:rogue_shooter/trait/timer_trait.dart';

class PlayerNode extends PositionNode with CollisionCallbacks {
  Vector2 _dragOffset = Vector2.zero();
  late final SpriteAnimation bullet;

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
          get<TimerTrait>().active = true;
        },
        onTapUp: (pointer) {
          get<TimerTrait>().active = false;
        },
      ),
    );
    addTrait(
      DraggableTrait(
        onStart: (pointer, offset) {
          _dragOffset = offset;
          pointer.handled = true;
          final timerTrait = get<TimerTrait>();
          if (timerTrait.active == false) {
            timerTrait.active = true;
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
          get<TimerTrait>().active = false;
        },
      ),
    );
    addTrait(
      TimerTrait(
        0.05,
        _createBullet,
        active: false,
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
  }

  @override
  void onMount() {
    super.onMount();
    bullet = realm!.getResource<SpriteSheetStorage>().bulletAnimation;
  }

  static const _bulletAngles = [0.5, 0.3, 0.0, -0.5, -0.3];
  void _createBullet() {
    realm!.addAll(
      _bulletAngles.map(
        (angle) => BulletNode(
          position: position + Vector2(0, -size.y / 2),
          angle: angle,
          bullet: bullet,
        ),
      ),
    );
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
