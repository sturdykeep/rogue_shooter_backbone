import 'package:flame/sprite.dart';

class SpriteSheetStorage {
  final SpriteSheet starSpriteSheet;
  final SpriteAnimation enemySpriteSheet;
  final SpriteAnimation playerAnimation;
  final SpriteAnimation bulletAnimation;
  SpriteSheetStorage(
    this.starSpriteSheet,
    this.enemySpriteSheet,
    this.playerAnimation,
    this.bulletAnimation,
  );
}
