import 'package:backbone/filter.dart';
import 'package:backbone/prelude/transform.dart';
import 'package:backbone/realm.dart';
import 'package:rogue_shooter/trait/clean_up_trait.dart';

void cleanUpSystem(Realm realm) {
  final query = realm.query(Has([CleanUpTrait, TransformTrait]));
  final gameSize = realm.gameRef.size;
  for (final node in query) {
    final transform = node.get<TransformTrait>();
    if (transform.position.y > gameSize.y) {
      node.removeFromParent();
    } else if (transform.position.y < 0 ||
        transform.position.x > gameSize.x ||
        transform.position.x + gameSize.x < 0) {
      node.removeFromParent();
    }
  }
}
