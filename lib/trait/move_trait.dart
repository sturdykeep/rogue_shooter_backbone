import 'package:backbone/trait.dart';
import 'package:flame/components.dart';

class MoveTrait extends ATrait {
  final Vector2 changeByFrame;

  MoveTrait(this.changeByFrame);
}
