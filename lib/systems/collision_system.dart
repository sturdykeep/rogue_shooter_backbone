import 'package:backbone/prelude/transform.dart';
import 'package:backbone/realm.dart';
import 'package:flame/components.dart';

const playerRadius = 25;
const enemyRadius = 13;
const bulletRadius = 5;

void collisionSystem(Realm realm) {
  /*
  final query = realm.query(Has([CollisionTrait]));
  final player = query.whereType<PlayerEntity>().first;
  final playerCenter = getCenter(player.get<Transform>());
  final enemies = query.whereType<EnemyEntity>();
  final bullets = query.whereType<BulletEntity>();
  for (final bullet in bullets) {
    final bulletCenter = getCenter(bullet.get<Transform>());
    for (final enemy in enemies) {
      final enemyCenter = getCenter(enemy.get<Transform>());
      if (collision(
        bulletCenter,
        enemyCenter,
        bulletRadius,
        enemyRadius,
      )) {
        enemy.takeHit();
      }
    }
  }
  for (final enemy in enemies) {
    final enemyCenter = getCenter(enemy.get<Transform>());
    if (collision(
      playerCenter,
      enemyCenter,
      playerRadius,
      enemyRadius,
    )) {
      enemy.takeHit();
    }
  }
  */
}

Vector2 getCenter(Transform transform) {
  return transform.position.clone() + transform.size.scaled(0.5);
}

bool collision(Vector2 centerA, Vector2 centerB, int radiusA, int radiusB) {
  final distanceBetweenCirclesSquared =
      (centerB.x - centerA.x) * (centerB.x - centerA.x) +
          (centerB.y - centerA.y) * (centerB.y - centerA.y);
  if (distanceBetweenCirclesSquared <=
      (radiusA + radiusB) * (radiusA + radiusB)) {
    return true;
  }
  return false;
}
