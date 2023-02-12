import 'package:backbone/filter.dart';
import 'package:backbone/prelude/transform.dart';
import 'package:backbone/realm.dart';
import 'package:rogue_shooter/trait/clean_up_trait.dart';

void cleanUpSystem(Realm realm) {
  final query = realm.query(Has([CleanUpTrait, TransformTrait]));
  final border = realm.gameRef.size.y;
  for (final node in query) {
    if (node.get<TransformTrait>().position.y > border) {
      node.removeFromParent();
    }
  }
}
