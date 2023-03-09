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

void collisionSystem(Realm realm) {
  final query = realm.query(Has([CollisionTrait]));
  final bullets = query.whereType<BulletEntity>();

  final player = query.whereType<PlayerEntity>().first;

  // Map entities to AABBs
  final aabbs = <AABB>[];
  final entityToAABB = <Entity, AABB>{};
  final AABBToEntity = <AABB, Entity>{};
  for (final entity in query) {
    final transform = entity.get<Transform>();
    final aabb = AABB.fromTransform(transform);
    aabbs.add(aabb);
    entityToAABB[entity] = aabb;
    AABBToEntity[aabb] = entity;
  }
  // Build up a QuadTree
  final quadTreeStack =
      QuadTreeStack(AABB(Vector2(-200, -200), realm.gameRef.size * 1.5));
  aabbs.forEach(quadTreeStack.insert);

  // Player <-> Enemies
  final playerAABB = entityToAABB[player]!;
  final playerCollisions = quadTreeStack.query(playerAABB);
  for (final collision in playerCollisions) {
    final entity = AABBToEntity[collision];
    if (entity is EnemyEntity) {
      entity.takeHit();
      AABBToEntity.remove(collision);
    }
  }

  // Bullets <-> Enemies
  final toRemove = <Entity>[];
  for (final bullet in bullets) {
    final bulletAABB = entityToAABB[bullet]!;
    final bulletCollisions = quadTreeStack.query(bulletAABB);
    for (final collision in bulletCollisions) {
      final entity = AABBToEntity[collision];
      if (entity is EnemyEntity) {
        entity.takeHit();
        AABBToEntity.remove(collision);
        toRemove.add(bullet);
      }
    }
  }

  // Remove entities
  toRemove.forEach((entity) => realm.removeEntity(entity));
}
