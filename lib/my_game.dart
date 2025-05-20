import 'dart:async';
import 'dart:math';

import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:space_havoc/components/asteroid.dart';
import 'package:space_havoc/components/audio_manager.dart';
import 'package:space_havoc/components/pickup.dart';
import 'package:space_havoc/components/shoot_button.dart';
import 'package:space_havoc/components/star.dart';

import 'components/player.dart';

class MyGame extends FlameGame with HasCollisionDetection {
  late Player player;
  late JoystickComponent joystick;
  late SpawnComponent _asteroidSpawner;
  late SpawnComponent _pickupSpawner;
  final Random _random = Random();
  late ShootButton _shootButton;
  int _score = 0;
  late TextComponent _scoreDisplay;
  final List<String> playerColors = ['blue', 'red', 'green', 'purple'];
  int playerColorIndex = 0;
  late final AudioManager audioManager;

  @override
  FutureOr<void> onLoad() async {
    await Flame.device.fullScreen();
    await Flame.device.setPortrait();

    audioManager = AudioManager();
    await add(audioManager);
    audioManager.playMusic();

    _createStars();

    // debugMode = true;

    // startGame();

    return super.onLoad();
  }

  void startGame() async {
    await _createJoystick();
    await _createPlayer();
    _createShootButton();
    _createPickupSpawner();
    _createAsteroidSpawner();

    _createScoreDisplay();
    // add(Asteroid(position: Vector2(200, 0)));
  }

  Future<void> _createPlayer() async {
    player =
        Player()
          ..anchor = Anchor.center
          ..position = Vector2(size.x / 2, size.y * 0.8);
    add(player);
  }

  Future<void> _createJoystick() async {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: await loadSprite('joystick_knob.png'),
        size: Vector2.all(50),
      ),
      // size: 50,
      background: SpriteComponent(
        sprite: await loadSprite('joystick_background.png'),
        size: Vector2.all(100),
      ),
      anchor: Anchor.bottomLeft,
      position: Vector2(40, size.y - 40),
      priority: 10,
    );

    add(joystick);
  }

  void _createAsteroidSpawner() {
    _asteroidSpawner = SpawnComponent.periodRange(
      minPeriod: 0.5,
      maxPeriod: 1.2,
      factory: (index) => Asteroid(position: _generateSpawnPosition()),
      selfPositioning: true,
    );
    add(_asteroidSpawner);
  }

  void _createPickupSpawner() {
    _pickupSpawner = SpawnComponent.periodRange(
      minPeriod: 3.0,
      maxPeriod: 9.0,
      selfPositioning: true,
      factory:
          (index) => Pickup(
            position: _generateSpawnPosition(),
            pickupType:
                PickupType.values[_random.nextInt(PickupType.values.length)],
          ),
    );
    add(_pickupSpawner);
  }

  Vector2 _generateSpawnPosition() {
    return Vector2(10 + _random.nextDouble() * (size.x - 10 * 2), -100);
  }

  void _createShootButton() {
    _shootButton =
        ShootButton()
          ..anchor = Anchor.bottomRight
          ..position = Vector2(size.x - 40, size.y - 50)
          ..priority = 10;
    add(_shootButton);
  }

  void _createScoreDisplay() {
    _score = 0;

    _scoreDisplay = TextComponent(
      text: '0',
      anchor: Anchor.center,
      position: Vector2(size.x / 2, 60),
      priority: 10,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 2),
          ],
        ),
      ),
    );

    add(_scoreDisplay);
  }

  void incrementScore(int amount) {
    _score += amount;
    _scoreDisplay.text = _score.toString();

    final ScaleEffect popEffect = ScaleEffect.to(
      Vector2.all(1.2),
      EffectController(
        duration: 0.05,
        alternate: true,
        curve: Curves.easeInOut,
      ),
    );

    _scoreDisplay.add(popEffect);
  }

  void _createStars() {
    for (int i = 0; i < 50; i++) {
      add(Star()..priority = -10);
    }
  }

  void playerDied() {
    overlays.add('Game Over');
    pauseEngine();
  }

  void restartGame() {
    children.whereType<PositionComponent>().forEach((component) {
      if (component is Asteroid || component is Pickup) {
        remove(component);
      }
    });

    _asteroidSpawner.timer.start();
    _pickupSpawner.timer.start();

    _score = 0;
    _scoreDisplay.text = '0';

    _createPlayer();

    resumeEngine();
  }

  void quitGame() {
    children.whereType<PositionComponent>().forEach((component) {
      if (component is! Star) {
        remove(component);
      }
    });

    remove(_asteroidSpawner);
    remove(_pickupSpawner);

    overlays.add('Title');
    resumeEngine();
  }
}
