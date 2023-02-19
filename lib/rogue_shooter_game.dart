import 'dart:math';

import 'package:backbone/backbone.dart';
import 'package:backbone/builders.dart';
import 'package:backbone/realm_mixin.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:rogue_shooter/node/player_node.dart';

import 'package:rogue_shooter/node/screen_text_node.dart';
import 'package:rogue_shooter/resources/game_score.dart';
import 'package:rogue_shooter/resources/sprite_storage.dart';
import 'package:rogue_shooter/systems/clean_up_system.dart';
import 'package:rogue_shooter/systems/enemy_creator_system.dart';
import 'package:rogue_shooter/systems/move_system.dart';
import 'package:rogue_shooter/systems/screen_text_system.dart';
import 'package:rogue_shooter/systems/star_creator_system.dart';
import 'package:rogue_shooter/systems/timer_system.dart';
import 'package:rogue_shooter/trait/clean_up_trait.dart';
import 'package:rogue_shooter/trait/move_trait.dart';
import 'package:rogue_shooter/trait/timer_trait.dart';

class RogueShooterGame extends FlameGame
    with HasCollisionDetection, KeyboardEvents, HasRealm {
  static const String description = '''
    A simple space shooter game used for testing performance of the collision
    detection system in Flame.
  ''';

  late final PlayerNode player;

  int score = 0;

  @override
  Future<void> onLoad() async {
    final startSheet = SpriteSheet.fromColumnsAndRows(
      image: await images.load('rogue_shooter/stars.png'),
      rows: 4,
      columns: 4,
    );
    final enemy = await loadSpriteAnimation(
      'rogue_shooter/enemy.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.2,
        amount: 4,
        textureSize: Vector2.all(16),
      ),
    );

    final playerAnimation = await loadSpriteAnimation(
      'rogue_shooter/player.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.2,
        amount: 4,
        textureSize: Vector2(32, 39),
      ),
    );
    final bullet = await loadSpriteAnimation(
      'rogue_shooter/bullet.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.2,
        amount: 4,
        textureSize: Vector2(8, 16),
      ),
    );
    final sprietStorage = SpriteSheetStorage(
      startSheet,
      enemy,
      playerAnimation,
      bullet,
    );
    realm = RealmBuilder()
        .withPlugin(defaultPlugin)
        .withPlugin(_roguePlugin)
        .withResource(SpriteSheetStorage, sprietStorage)
        .build();
    add(realm);
    //Create an initial starfield
    const gapSize = 12;
    final rows = size.y / gapSize;

    for (var i = 0; i < gapSize; i++) {
      createStarRow(i * rows, realm);
    }
    realm.add(
      player = PlayerNode(
        sprietStorage.playerAnimation,
      ),
    );

    realm.addAll([
      FpsTextComponent(
        position: size - Vector2(0, 50),
        anchor: Anchor.bottomRight,
      ),
      ScreenTextNode(Vector2(15, size.y - 100)),
    ]);
    realm.logPerformanceData = true;
    realmReady = true;
  }

  void _roguePlugin(RealmBuilder builder) {
    builder
        .withSystem(enemyCreatorSystem)
        .withSystem(starCreatorSystem)
        .withTrait(MoveTrait)
        .withTrait(CleanUpTrait)
        .withTrait(TimerTrait)
        .withSystem(timerSystem)
        .withSystem(moveSystem)
        .withSystem(cleanUpSystem)
        .withSystem(screenTextSystem)
        .withResource(GameScore, GameScore())
        .withResource(Random, Random());
  }
}
