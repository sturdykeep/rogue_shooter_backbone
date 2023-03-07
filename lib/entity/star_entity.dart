
import 'package:backbone/entity.dart';
import 'package:backbone/prelude/render/sprite.dart';
import 'package:backbone/prelude/render/trait.dart';
import 'package:backbone/prelude/transform.dart';
import 'package:flame/components.dart';
import 'package:rogue_shooter/trait/clean_up_trait.dart';
import 'package:rogue_shooter/trait/move_trait.dart';

class StarEntity extends Entity {
  static const speed = 10;

  StarEntity({
    required Vector2 position,
    required SpriteAnimation animation,
  }) : super() {
    add(
      Transform()
        ..size = Vector2.all(20)
        ..position = position,
    );
    add(CleanUpTrait());
    add(MoveTrait(Vector2(0, 10)));
    add(
      Renderable(
        visual: SpriteAnimationVisual(
          animation: animation,
        ),
      ),
    );
  }
}
