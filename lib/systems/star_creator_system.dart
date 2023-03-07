import 'dart:math';

import 'package:backbone/prelude/time.dart';
import 'package:backbone/realm.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:rogue_shooter/entity/star_entity.dart';
import 'package:rogue_shooter/resources/sprite_storage.dart';

double starTime = 0;

void starCreatorSystem(Realm realm) {
  const gapSize = 12;
  final gameRef = realm.gameRef;
  const starSpeed = 10;
  final starGapTime = (gameRef.size.y / gapSize) / starSpeed;
  final time = realm.resource<Time>();
  starTime += time.delta;

  if (starTime >= starGapTime) {
    starTime = 0;
    createStarRow(0, realm);
  }
}

void createStarRow(double y, Realm realm) {
  final storage = realm.resource<SpriteSheetStorage>();
  final random = realm.resource<Random>();
  final gameRef = realm.gameRef;
  const gapSize = 6;
  final starGap = gameRef.size.x / gapSize;

  for (var i = 0; i < gapSize; i++) {
    createStar(
      starGap * i + (random.nextDouble() * starGap),
      y + (random.nextDouble() * 20),
      storage.starSpriteSheet,
      realm,
      random,
    );
  }
}

void createStar(
  double x,
  double y,
  SpriteSheet spriteSheet,
  Realm realm,
  Random random,
) {
  final animation = spriteSheet.createAnimation(
    row: random.nextInt(3),
    to: 4,
    stepTime: 0.1,
  )..variableStepTimes = [max(20, 100 * random.nextDouble()), 0.1, 0.1, 0.1];

  realm.addEntity(
    StarEntity(animation: animation, position: Vector2(x, y)),
  );
}
