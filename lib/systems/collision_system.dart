import 'package:backbone/filter.dart';
import 'package:backbone/prelude/transform.dart';
import 'package:backbone/realm.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:rogue_shooter/entity/bullet_entity.dart';
import 'package:rogue_shooter/entity/enemy_entity.dart';
import 'package:rogue_shooter/entity/player_entity.dart';
import 'package:rogue_shooter/trait/collision_trait.dart';

class AABB {
  final Vector2 position;
  final Vector2 size;

  AABB(this.position, this.size);

  AABB.fromTransform(Transform transform)
      : position = transform.position,
        size = transform.size;

  bool collidesWith(AABB other) {
    final xOverlap =
        (position.x - other.position.x).abs() * 2 < (size.x + other.size.x);
    final yOverlap =
        (position.y - other.position.y).abs() * 2 < (size.y + other.size.y);
    return xOverlap && yOverlap;
  }

  bool collidesWithTransform(Transform transform) {
    return collidesWith(AABB.fromTransform(transform));
  }
}

void collisionSystem(Realm realm) {
  final query = realm.query(Has([CollisionTrait]));
  final player = query.whereType<PlayerEntity>().first;
  final playerTransform = player.get<Transform>();
  final enemies = query.whereType<EnemyEntity>();
  final bullets = query.whereType<BulletEntity>();

  // Player <-> Enemies
  for (final enemy in enemies) {
    final enemyTransform = enemy.get<Transform>();
    if (collision(playerTransform, enemyTransform)) {
      enemy.takeHit();
    }
  }

  // Bullets <-> Enemies
  for (final bullet in bullets) {
    final bulletTransform = bullet.get<Transform>();
    for (final enemy in enemies) {
      final enemyTransform = enemy.get<Transform>();
      if (collision(bulletTransform, enemyTransform)) {
        enemy.takeHit();
        // bullet.destroy();
      }
    }
  }
}

bool collision(Transform a, Transform b) {
  return AABB.fromTransform(a).collidesWithTransform(b);
}
