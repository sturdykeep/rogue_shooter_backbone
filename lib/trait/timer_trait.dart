import 'package:backbone/trait.dart';

class TimerTrait extends ATrait {
  double last = 0;
  late bool _active;
  bool get active => _active;
  set active(bool value) {
    if (value == false) {
      last = 0;
    }
    _active = value;
  }

  late double period;
  late void Function() callback;
  TimerTrait(this.period, this.callback, {bool active = true}) {
    this.active = active;
  }
}
