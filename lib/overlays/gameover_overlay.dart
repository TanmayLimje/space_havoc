import 'package:flutter/material.dart';
import 'package:space_havoc/my_game.dart';

class GameOverOverlay extends StatefulWidget {
  final MyGame game;

  const GameOverOverlay({super.key, required this.game});

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay> {
  double _opacity = 0.4;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 0), (){
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      onEnd: () {
        if(_opacity == 0.0){
          widget.game.overlays.remove('Game Over');
        }
      },
      opacity: _opacity,
      duration: const Duration(milliseconds: 500),
      child: Container(
        color: Colors.black.withAlpha(150),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "GAME OVER",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 50,
              ),
            ),
            SizedBox(height: 30),
            TextButton(
              onPressed: (){
                // widget.game.audioManager.playSound('start');

                widget.game.restartGame();
                setState(() {
                  _opacity = 0.0;
                });
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                "Play Again",
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
            ),
            SizedBox(height: 15),
            TextButton(
              onPressed: () {
                // widget.game.audioManager.playSound('start');

                widget.game.quitGame();
                setState(() {
                  _opacity = 0.0;
                });
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                "Quit Game",
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
