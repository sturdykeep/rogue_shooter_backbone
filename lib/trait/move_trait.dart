import 'package:backbone/trait.dart';
import 'package:flame/components.dart';

class MoveTrait extends Trait {
  final Vector2 changeByFrame;

  MoveTrait(this.changeByFrame);
}
