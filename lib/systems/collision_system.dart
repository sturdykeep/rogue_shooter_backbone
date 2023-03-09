import 'package:backbone/entity.dart';
import 'package:backbone/filter.dart';
import 'package:backbone/prelude/transform.dart';
import 'package:backbone/realm.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:rogue_shooter/entity/bullet_entity.dart';
import 'package:rogue_shooter/entity/enemy_entity.dart';
import 'package:rogue_shooter/entity/player_entity.dart';
import 'package:rogue_shooter/quad_tree.dart';
import 'package:rogue_shooter/trait/collision_trait.dart';
import 'package:rogue_shooter/trait/to_remove_trait.dart';

void collisionSystem(Realm realm) {
  final query = realm.query(Has([CollisionTrait]));
  final bullets = query.whereType<BulletEntity>();

  final player = query.whereType<PlayerEntity>().first;

  // Map entities to AABBs
  final entityToAABB = <Entity, AABB>{};
  final AABBToEntity = <AABB, Entity>{};
  for (final entity in query) {
    final transform = entity.get<Transform>();
    final aabb = AABB.fromTransform(transform);
    entityToAABB[entity] = aabb;
    AABBToEntity[aabb] = entity;
  }
  // Build up a QuadTree
  final quadTreeStack =
      QuadTreeStack(AABB(Vector2(-200, -200), realm.gameRef.size * 1.5));
  for (final aabb in entityToAABB.values) {
    quadTreeStack.insert(aabb);
  }

  // Player <-> Enemies
  final playerAABB = entityToAABB[player]!;
  final playerCollisions = quadTreeStack.query(playerAABB);
  for (final collision in playerCollisions) {
    final entity = AABBToEntity[collision]!;
    if (entity is EnemyEntity) {
      entity.takeHit();
    }
  }

  // Bullets <-> Enemies
  final toRemove = <Entity>[];
  for (final bullet in bullets) {
    final bulletAABB = entityToAABB[bullet]!;
    final bulletCollisions = quadTreeStack.query(bulletAABB);
    for (final collision in bulletCollisions) {
      final entity = AABBToEntity[collision]!;
      if (entity is EnemyEntity) {
        entity.takeHit();
        toRemove.add(bullet);
      }
    }
  }

  // Remove entities
  toRemove.forEach((entity) => realm.removeEntity(entity));
}
