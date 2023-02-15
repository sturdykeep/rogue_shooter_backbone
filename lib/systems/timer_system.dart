import 'package:backbone/filter.dart';
import 'package:backbone/prelude/time.dart';
import 'package:backbone/realm.dart';
import 'package:rogue_shooter/trait/timer_trait.dart';

void timerSystem(Realm realm) {
  final nodes = realm.query(Has([TimerTrait]));
  final time = realm.getResource<Time>();
  for (final node in nodes) {
    final timerTrait = node.get<TimerTrait>();
    if (timerTrait.active == false) {
      continue;
    }
    timerTrait.last += time.delta;
    if (timerTrait.last >= timerTrait.period) {
      timerTrait.last = 0;
      timerTrait.callback();
    }
  }
}
