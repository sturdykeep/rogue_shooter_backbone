import 'dart:async';

import 'package:backbone/position_component.dart';
import 'package:backbone/prelude/text/trait.dart';
import 'package:backbone/prelude/transform.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/widgets.dart' hide Transform;

class ScreenTextNode extends PositionEntityComponent {
  late TextTrait textTrait;

  ScreenTextNode(Vector2 position)
      : super(
          transformTrait: Transform()..position = position,
        ) {
    textTrait = TextTrait();
    textTrait.anchor = Anchor.topLeft;
    textTrait.style = const TextStyle(
      color: Color(0xFFFFFFFF),
      fontFamily: 'Arial',
      fontSize: 24,
    );
    priority = 1;
  }

  @override
  FutureOr<void> onLoad() {
    add(TextComponent());
    return super.onLoad();
  }

  @override
  void onMount() {
    super.onMount();
    entity.add(textTrait);
  }
}
