import 'package:backbone/filter.dart';
import 'package:backbone/prelude/time.dart';
import 'package:backbone/prelude/transform.dart';
import 'package:backbone/realm.dart';
import 'package:rogue_shooter/trait/move_trait.dart';

void moveSystem(Realm realm) {
  final query = realm.query(Has([MoveTrait, TransformTrait]));
  final time = realm.getResource<Time>();
  for (final node in query) {
    final transform = node.get<TransformTrait>();
    final move = node.get<MoveTrait>();
    transform.position += move.changeByFrame.scaled(time.delta);
  }
}
