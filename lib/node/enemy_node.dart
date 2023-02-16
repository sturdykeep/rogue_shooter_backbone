import 'package:backbone/position_node.dart';
import 'package:backbone/prelude/sprite/trait.dart';
import 'package:backbone/prelude/transform.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:rogue_shooter/components/explosion_component.dart';
import 'package:rogue_shooter/resources/game_score.dart';
import 'package:rogue_shooter/trait/clean_up_trait.dart';
import 'package:rogue_shooter/trait/move_trait.dart';

class EnemyNode extends PositionNode with CollisionCallbacks {
  static const speed = 150;
  static Vector2 initialSize = Vector2.all(25);

  EnemyNode({
    required Vector2 position,
    required SpriteAnimation animation,
  }) : super(
          transformTrait: TransformTrait()
            ..size = initialSize
            ..anchor = Anchor.center
            ..position = position,
        ) {
    addTrait(CleanUpTrait());
    final spriteTrait = SpriteTrait();
    spriteTrait.animationData = animation;
    addTrait(MoveTrait(Vector2(0, 150)));
    addTrait(spriteTrait);
  }

  @override
  Future<void> onLoad() async {
    add(
      SpriteAnimationComponent(
        animation: get<SpriteTrait>().animationData,
      ),
    );
    add(CircleHitbox()..collisionType = CollisionType.passive);
  }

  void takeHit() {
    transformTrait.position.y = gameRef.size.y + 1;
    realm!.add(ExplosionComponent(position: position));
    realm!.getResource<GameScore>().currentScore++;
  }
}
