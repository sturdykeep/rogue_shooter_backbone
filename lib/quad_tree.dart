import 'dart:math';

import 'package:backbone/prelude/transform.dart';
import 'package:flame/extensions.dart';

class AABB {
  final Vector2 position;
  final Vector2 size;

  AABB(this.position, this.size);

  factory AABB.fromTransform(Transform transform) {
    final globalTransform = transform.globalTransformMatrix;
    final topLeft = globalTransform.transform2(
      Vector2.zero(),
    );
    final topRight = globalTransform.transform2(
      Vector2(transform.size.x, 0),
    );
    final bottomLeft = globalTransform.transform2(
      Vector2(0, transform.size.y),
    );
    final bottomRight = globalTransform.transform2(
      Vector2(transform.size.x, transform.size.y),
    );

    // Min and max values
    final minX = min(
      min(topLeft.x, topRight.x),
      min(bottomLeft.x, bottomRight.x),
    );
    final maxX = max(
      max(topLeft.x, topRight.x),
      max(bottomLeft.x, bottomRight.x),
    );
    final minY = min(
      min(topLeft.y, topRight.y),
      min(bottomLeft.y, bottomRight.y),
    );
    final maxY = max(
      max(topLeft.y, topRight.y),
      max(bottomLeft.y, bottomRight.y),
    );

    // Build AABB
    final position = Vector2(minX, minY);
    final size = Vector2(maxX - minX, maxY - minY);
    return AABB(position, size);
  }

  bool collidesWith(AABB aabb) {
    return position.x < aabb.position.x + aabb.size.x &&
        position.x + size.x > aabb.position.x &&
        position.y < aabb.position.y + aabb.size.y &&
        position.y + size.y > aabb.position.y;
  }

  bool containsPoint(Vector2 point) {
    return point.x >= position.x &&
        point.x <= position.x + size.x &&
        point.y >= position.y &&
        point.y <= position.y + size.y;
  }

  bool contains(AABB aabb) {
    return containsPoint(aabb.position) &&
        containsPoint(aabb.position + aabb.size);
  }

  @override
  String toString() {
    return 'AABB(position: $position, size: $size)';
  }
}

class QuadTree {
  static const int maxObjects = 5;

  final List<AABB> objects = [];
  final AABB bounds;
  final List<QuadTree> nodes = [];

  QuadTree({
    required this.bounds,
  });

  void clear() {
    objects.clear();
    nodes.forEach((node) => node.clear());
    nodes.clear();
  }

  void subdivide() {
    final subWidth = bounds.size.x / 2;
    final subHeight = bounds.size.y / 2;
    final x = bounds.position.x;
    final y = bounds.position.y;

    nodes.add(
      QuadTree(
        bounds: AABB(
          Vector2(x + subWidth, y),
          Vector2(subWidth, subHeight),
        ),
      ),
    );
    nodes.add(
      QuadTree(
        bounds: AABB(
          Vector2(x, y),
          Vector2(subWidth, subHeight),
        ),
      ),
    );
    nodes.add(
      QuadTree(
        bounds: AABB(
          Vector2(x, y + subHeight),
          Vector2(subWidth, subHeight),
        ),
      ),
    );
    nodes.add(
      QuadTree(
        bounds: AABB(
          Vector2(x + subWidth, y + subHeight),
          Vector2(subWidth, subHeight),
        ),
      ),
    );
  }

  bool insert(AABB aabb) {
    if (bounds.contains(aabb) == false) {
      return false;
    }

    if (objects.length < maxObjects && nodes.isEmpty) {
      objects.add(aabb);
      return true;
    }

    // Otherwise, we need to subdivide first
    if (nodes.isEmpty) {
      subdivide();
    }

    // Insert into the appropriate node
    for (final node in nodes) {
      if (node.insert(aabb)) {
        return true;
      }
    }

    // Otherwise, the object cannot be inserted for some reason (this should never happen)
    return false;
  }

  List<AABB> query(AABB range, {bool contains = false}) {
    final found = <AABB>[];

    // Automatically abort if the range does not intersect this quad
    if (bounds.collidesWith(range) == false) {
      return found;
    }

    // Check objects at this quad level
    for (final object in objects) {
      if (contains && range.contains(object)) {
        found.add(object);
      } else if (range.collidesWith(object)) {
        found.add(object);
      }
    }

    // Terminate here, if there are no children
    if (nodes.isEmpty) {
      return found;
    }

    // Otherwise, add the objects from the children
    for (final node in nodes) {
      found.addAll(node.query(range));
    }

    return found;
  }

  int get totalObjects {
    var total = objects.length;
    for (final node in nodes) {
      total += node.totalObjects;
    }
    return total;
  }

  @override
  String toString() {
    // Formatted with indentation
    const indent = '  ';
    final sb = StringBuffer();
    sb.writeln(
        'QuadTree(bounds: $bounds, objects: ${objects.length}, total: $totalObjects)');
    for (final node in nodes) {
      sb.writeln(indent + node.toString().replaceAll('\n', '\n$indent'));
    }
    return sb.toString();
  }
}

class QuadTreeStack {
  final AABB bounds;
  final List<QuadTree> nodes = [];

  QuadTreeStack(this.bounds);

  void clear() {
    nodes.forEach((node) => node.clear());
    nodes.clear();
  }

  void insert(AABB aabb) {
    if (bounds.contains(aabb) == false) {
      return;
    }

    while (true) {
      // Try to insert into all the existing nodes, until one inserts
      // or add a new node
      var inserted = false;
      for (final node in nodes) {
        if (node.insert(aabb)) {
          inserted = true;
          break;
        }
      }

      if (inserted) {
        break;
      }

      // Otherwise, we need to subdivide first
      final node = QuadTree(bounds: bounds);
      if (node.insert(aabb) == false) {
        throw StateError('Could not insert into new node');
      }
      nodes.add(node);
    }
  }

  List<AABB> query(AABB range) {
    final found = <AABB>[];

    // Automatically abort if the range does not intersect this quad
    if (bounds.collidesWith(range) == false) {
      return found;
    }

    // Check objects at this quad level
    for (final node in nodes) {
      found.addAll(node.query(range));
    }

    return found;
  }
}
