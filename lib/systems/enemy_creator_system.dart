import 'dart:math';

import 'package:backbone/prelude/time.dart';
import 'package:backbone/realm.dart';
import 'package:flame/game.dart';
import 'package:rogue_shooter/entity/enemy_entity.dart';
import 'package:rogue_shooter/resources/sprite_storage.dart';

double timePassed = 0;
const int totalEnemys = 800;
int addedEnemies = 0;
void enemyCreatorSystem(Realm realm) {
  if (addedEnemies >= totalEnemys) {
    return;
  }
  final time = realm.resource<Time>();
  timePassed += time.delta;

  if (timePassed >= 0.05) {
    final storage = realm.resource<SpriteSheetStorage>();
    timePassed = 0;
    final _halfWidth = EnemyEntity.initialSize.x / 2;
    final random = realm.resource<Random>();
    final gameRef = realm.gameRef;

    List.generate(
      5,
      (index) => EnemyEntity(
        position: Vector2(
          _halfWidth + (gameRef.size.x - _halfWidth) * random.nextDouble(),
          0,
        ),
        animation: storage.enemySpriteSheet,
      ),
    ).forEach((element) => realm.addEntity(element));
    addedEnemies += 5;
  }
}
