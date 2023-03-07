import 'package:backbone/entity.dart';
import 'package:backbone/prelude/render/sprite.dart';
import 'package:backbone/prelude/render/trait.dart';
import 'package:backbone/prelude/transform.dart';
import 'package:flame/components.dart';
import 'package:rogue_shooter/components/explosion_component.dart';
import 'package:rogue_shooter/resources/game_score.dart';
import 'package:rogue_shooter/trait/clean_up_trait.dart';
import 'package:rogue_shooter/trait/collision_trait.dart';
import 'package:rogue_shooter/trait/move_trait.dart';

class EnemyEntity extends Entity /* with CollisionCallbacks */ {
  static const speed = 150;
  static Vector2 initialSize = Vector2.all(25);

  EnemyEntity({
    required Vector2 position,
    required SpriteAnimation animation,
  }) : super() {
    final transform = Transform()
      ..size = initialSize
      ..anchor = Anchor.center
      ..position = position;
    add(transform);
    add(CollisionTrait(13));
    add(CleanUpTrait());
    add(
      Renderable(
        visual: SpriteAnimationVisual(
          animation: animation,
        ),
      ),
    );
    add(MoveTrait(Vector2(0, 150)));
  }

  void takeHit() {
    final transfrom = get<Transform>();
    realm!.add(ExplosionComponent(position: transfrom.position));
    transfrom.position.y = realm!.gameRef.size.y + 1;

    realm!.resource<GameScore>().currentScore++;
  }
}
