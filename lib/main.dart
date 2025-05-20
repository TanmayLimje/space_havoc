import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:space_havoc/my_game.dart';
import 'package:space_havoc/overlays/gameover_overlay.dart';
import 'package:space_havoc/overlays/title_overlay.dart';

void main() {
  final MyGame game = MyGame();
  runApp(
    GameWidget(
      game: game,
      overlayBuilderMap: {
        'Game Over': (context, MyGame game) => GameOverOverlay(game: game),
        'Title': (context, MyGame game) => TitleOverlay(game: game),
      },
      initialActiveOverlays: const ['Title'],
    ),
  );
}
