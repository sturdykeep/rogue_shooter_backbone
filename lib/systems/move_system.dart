import 'package:backbone/filter.dart';
import 'package:backbone/prelude/time.dart';
import 'package:backbone/prelude/transform.dart';
import 'package:backbone/realm.dart';
import 'package:rogue_shooter/trait/move_trait.dart';

void moveSystem(Realm realm) {
  final query = realm.query(Has([MoveTrait, Transform]));
  final time = realm.resource<Time>();
  for (final entitiy in query) {
    final transform = entitiy.get<Transform>();
    final move = entitiy.get<MoveTrait>();
    transform.position += move.changeByFrame.scaled(time.delta);
  }
}
