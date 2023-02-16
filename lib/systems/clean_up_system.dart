import 'dart:math';

import 'package:backbone/filter.dart';
import 'package:backbone/prelude/transform.dart';
import 'package:backbone/realm.dart';
import 'package:flame/game.dart';
import 'package:rogue_shooter/node/enemy_node.dart';
import 'package:rogue_shooter/trait/clean_up_trait.dart';

void cleanUpSystem(Realm realm) {
  final query = realm.query(Has([CleanUpTrait, TransformTrait]));
  final gameSize = realm.gameRef.size;
  for (final node in query) {
    final transform = node.get<TransformTrait>();
    if (transform.position.y > gameSize.y) {
      if (node is EnemyNode) {
        final _halfWidth = EnemyNode.initialSize.x / 2;
        final gameRef = node.gameRef;
        final random = realm.getResource<Random>();
        transform.position = Vector2(
          _halfWidth + (gameRef.size.x - _halfWidth) * random.nextDouble(),
          0,
        );
      } else {
        node.removeFromParent();
      }
    } else if (transform.position.y < 0 ||
        transform.position.x > gameSize.x ||
        transform.position.x + gameSize.x < 0) {
      node.removeFromParent();
    }
  }
}
