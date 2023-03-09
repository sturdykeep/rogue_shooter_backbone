import 'dart:math';

import 'package:backbone/entity.dart';
import 'package:backbone/filter.dart';
import 'package:backbone/prelude/transform.dart';
import 'package:backbone/realm.dart';
import 'package:flame/input.dart';
import 'package:rogue_shooter/entity/enemy_entity.dart';
import 'package:rogue_shooter/trait/clean_up_trait.dart';

void cleanUpSystem(Realm realm) {
  final query = realm.query(Has([CleanUpTrait, Transform]));
  final gameSize = realm.gameRef.size;
  final markedToBeRemoved = <Entity>[];

  for (final entity in query) {
    final transform = entity.get<Transform>();
    if (transform.position.y > gameSize.y) {
      if (entity is EnemyEntity) {
        final _halfWidth = EnemyEntity.initialSize.x / 2;
        final gameRef = realm.gameRef;
        final random = realm.resource<Random>();
        transform.position = Vector2(
          _halfWidth + (gameRef.size.x - _halfWidth) * random.nextDouble(),
          0,
        );
      } else {
        markedToBeRemoved.add(entity);
      }
    } else if (transform.position.y < 0 ||
        transform.position.x > gameSize.x ||
        transform.position.x + gameSize.x < 0) {
      // Required to avoid Concurrent modification during iteration: Instance of 'List<Entity>'.
      markedToBeRemoved.add(entity);
    }
  }

  //TODO Helper function on entity to remove from realm
  markedToBeRemoved.forEach((element) => realm.removeEntity(element));
}
