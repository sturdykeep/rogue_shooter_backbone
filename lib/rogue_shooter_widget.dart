import 'package:backbone/widget.dart';
import 'package:flutter/widgets.dart';
import 'package:rogue_shooter/rogue_shooter_game.dart';

class RogueShooterWidget extends StatelessWidget {
  const RogueShooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BackboneGameWidget(
      game: RogueShooterGame(),
      loadingBuilder: (_) => const Center(
        child: Text('Loading'),
      ),
    );
  }
}
