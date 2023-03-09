import 'package:backbone/entity.dart';
import 'package:backbone/prelude/render/sprite.dart';
import 'package:backbone/prelude/render/trait.dart';
import 'package:backbone/prelude/transform.dart';
import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:rogue_shooter/entity/explosion_entity.dart';
import 'package:rogue_shooter/resources/game_score.dart';
import 'package:rogue_shooter/trait/clean_up_trait.dart';
import 'package:rogue_shooter/trait/collision_trait.dart';
import 'package:rogue_shooter/trait/move_trait.dart';

class EnemyEntity extends Entity /* with CollisionCallbacks */ {
  static const speed = 150;
  static Vector2 initialSize = Vector2.all(25);
  final SpriteAnimation explosionAnimation;

  EnemyEntity({
    required Vector2 position,
    required SpriteAnimation animation,
    required this.explosionAnimation,
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
          animation: animation.clone(),
        ),
      ),
    );
    add(MoveTrait(Vector2(0, 150)));
  }

  void takeHit() {
    final transfrom = get<Transform>();
    if (realm!.gameRef.size.y + 1 == transfrom.position.y) {
      debugPrint('test');
    }
    realm!.addEntity(
      ExplosionEntity(
        position: transfrom.position.clone(),
        animation: explosionAnimation,
      ),
    );
    transfrom.position.y = realm!.gameRef.size.y + 1;

    realm!.resource<GameScore>().currentScore++;
  }
}
