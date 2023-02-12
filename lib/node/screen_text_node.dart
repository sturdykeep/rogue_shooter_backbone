import 'dart:async';

import 'package:backbone/position_node.dart';
import 'package:backbone/prelude/text/trait.dart';
import 'package:backbone/prelude/transform.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ScreenTextNode extends PositionNode {
  ScreenTextNode(Vector2 position)
      : super(
          transformTrait: TransformTrait()..position = position,
        ) {
    final textTrait = TextTrait();
    textTrait.anchor = Anchor.topLeft;
    textTrait.style = const TextStyle(
      color: Color(0xFFFFFFFF),
      fontFamily: 'Arial',
      fontSize: 24,
    );
    priority = 1;
    addTrait(textTrait);
  }

  @override
  FutureOr<void> onLoad() {
    add(TextComponent());
    return super.onLoad();
  }
}
