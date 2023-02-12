import 'package:backbone/filter.dart';
import 'package:backbone/prelude/text/trait.dart';
import 'package:backbone/realm.dart';
import 'package:rogue_shooter/resources/game_score.dart';

void screenTextSystem(Realm realm) {
  final query = realm.query(Has([TextTrait]));
  final score = realm.getResource<GameScore>();
  for (final node in query) {
    final textTrait = node.get<TextTrait>();

    final text =
        'Score: ${score.currentScore}\nComponents: ${realm.children.length}';

    textTrait.text = text;
  }
}
