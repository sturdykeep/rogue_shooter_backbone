import 'dart:async';

import 'package:backbone/position_node.dart';
import 'package:backbone/prelude/sprite/trait.dart';
import 'package:backbone/prelude/transform.dart';
import 'package:flame/components.dart';
import 'package:rogue_shooter/trait/clean_up_trait.dart';
import 'package:rogue_shooter/trait/move_trait.dart';

class StarNode extends PositionNode {
  static const speed = 10;

  StarNode({required SpriteAnimation animation, required Vector2 position})
      : super(
          transformTrait: TransformTrait()
            ..size = Vector2.all(20)
            ..position = position,
        ) {
    addTrait(CleanUpTrait());
    addTrait(MoveTrait(Vector2(0, 10)));
    final sprite = SpriteTrait();
    sprite.animationData = animation;
    addTrait(sprite);
  }

  @override
  FutureOr<void> onLoad() {
    add(
      SpriteAnimationComponent(
        animation: get<SpriteTrait>().animationData,
      ),
    );
    return super.onLoad();
  }
}
