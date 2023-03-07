import 'dart:async';

import 'package:backbone/position_component.dart';
import 'package:backbone/prelude/text/trait.dart';
import 'package:backbone/prelude/transform.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/widgets.dart' hide Transform;

class ScreenTextNode extends PositionEntityComponent {
  ScreenTextNode(Vector2 position)
      : super(
          transform: Transform()..position = position,
        ) {
    final textTrait = TextTrait();
    textTrait.anchor = Anchor.topLeft;
    textTrait.style = const TextStyle(
      color: Color(0xFFFFFFFF),
      fontFamily: 'Arial',
      fontSize: 24,
    );
    priority = 1;
    entity.add(textTrait);
  }

  @override
  FutureOr<void> onLoad() {
    add(TextComponent());
    return super.onLoad();
  }
}
