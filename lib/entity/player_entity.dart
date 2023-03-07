import 'package:backbone/entity.dart';
import 'package:backbone/prelude/input/plugins/drag.dart';
import 'package:backbone/prelude/input/plugins/taps.dart';
import 'package:backbone/prelude/render/sprite.dart';
import 'package:backbone/prelude/render/trait.dart';
import 'package:backbone/prelude/transform.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:rogue_shooter/entity/bullet_entity.dart';
import 'package:rogue_shooter/resources/sprite_storage.dart';
import 'package:rogue_shooter/trait/collision_trait.dart';
import 'package:rogue_shooter/trait/timer_trait.dart';

class PlayerEntity extends Entity /*with CollisionCallbacks*/ {
  Vector2 _dragOffset = Vector2.zero();
  late final SpriteAnimation bullet;

  PlayerEntity(SpriteSheetStorage storage) : super() {
    final transfrom = Transform()
      ..size = Vector2(50, 75)
      ..position = Vector2(100, 500)
      ..anchor = Anchor.center;
    add(transfrom);
    add(CollisionTrait(25));
    add(
      Renderable(
        visual: SpriteAnimationVisual(
          animation: storage.playerAnimation,
        ),
      ),
    );
    bullet = storage.bulletAnimation;

    add(
      Tappable(
        onTapDown: (pointer) {
          get<TimerTrait>().active = true;
        },
        onTapUp: (pointer) {
          get<TimerTrait>().active = false;
        },
      ),
    );
    add(
      Draggable(
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
          final transform = get<Transform>();
          transform.position = pointer.position;
          transform.position -= _dragOffset;
        },
        onEnd: (pointer) {
          pointer.handled = true;
          get<TimerTrait>().active = false;
        },
      ),
    );

    add(
      TimerTrait(
        0.05,
        _createBullet,
        active: false,
      ),
    );
  }
  static const _bulletAngles = [0.5, 0.3, 0.0, -0.5, -0.3];
  void _createBullet() {
    final transform = get<Transform>();
    final currentPosition = transform.position;
    final offset = -transform.size.y / 2;

    _bulletAngles
        .map(
          (angle) => BulletEntity(
            position: currentPosition + Vector2(0, offset),
            angle: angle,
            bullet: bullet,
          ),
        )
        .forEach(
          (element) => realm!.addEntity(element),
        );
  }
  /*
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
  */
}
