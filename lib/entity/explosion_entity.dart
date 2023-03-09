import 'package:backbone/entity.dart';
import 'package:backbone/filter.dart';
import 'package:backbone/prelude/render/sprite.dart';
import 'package:backbone/prelude/render/trait.dart';
import 'package:backbone/prelude/transform.dart';
import 'package:backbone/realm.dart';
import 'package:backbone/trait.dart';
import 'package:flame/components.dart';

void explosionDoneSystem(Realm realm) {
  final query = realm.query(Has([ExplosionTrait]));
  final markedToBeRemoved = <Entity>[];
  for (final entity in query) {
    final renderable = entity.get<Renderable>();
    final animation = renderable.visual as SpriteAnimationVisual?;
    if (animation != null && animation.isComplete) {
      markedToBeRemoved.add(entity);
    }
  }

  markedToBeRemoved.forEach((entity) {
    realm.removeEntity(entity);
  });
}

class ExplosionTrait extends Trait {}

class ExplosionEntity extends Entity {
  ExplosionEntity({
    required Vector2 position,
    required SpriteAnimation animation,
  }) {
    add(ExplosionTrait());
    final transform = Transform()
      ..size = Vector2.all(50)
      ..anchor = Anchor.center
      ..position = position;
    add(transform);
    final thisAnimation = animation.clone();
    add(
      Renderable(
        visual: SpriteAnimationVisual(
          animation: thisAnimation,
        ),
      ),
    );
  }
}
