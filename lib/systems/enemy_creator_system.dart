import 'dart:math';

import 'package:backbone/prelude/time.dart';
import 'package:backbone/realm.dart';
import 'package:flame/game.dart';
import 'package:rogue_shooter/node/enemy_node.dart';
import 'package:rogue_shooter/resources/sprite_storage.dart';

double timePassed = 0;

void enemyCreatorSystem(Realm realm) {
  final time = realm.getResource<Time>();
  timePassed += time.delta;
  if (timePassed >= 0.05) {
    final storage = realm.getResource<SpriteSheetStorage>();
    timePassed = 0;
    final _halfWidth = EnemyNode.initialSize.x / 2;
    final random = realm.getResource<Random>();
    final gameRef = realm.gameRef;

    realm.addAll(
      List.generate(
        5,
        (index) => EnemyNode(
          position: Vector2(
            _halfWidth + (gameRef.size.x - _halfWidth) * random.nextDouble(),
            0,
          ),
          animation: storage.enemySpriteSheet,
        ),
      ),
    );
  }
}
