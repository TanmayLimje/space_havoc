import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
// import 'package:assets_audio_player/assets_audio_player.dart';

class AudioManager extends Component {
  bool musicEnabled = true;
  bool soundsEnabled = true;

  final List<String> _sounds = [
    'click',
    'collect',
    'explode1',
    'explode2',
    'fire',
    'hit',
    'laser',
    'start',
  ];

  // final Map<String, Audio> _soundAssets = {};
  // final AssetsAudioPlayer _soundPlayer = AssetsAudioPlayer.newPlayer();

  @override
  FutureOr<void> onLoad() async {
    FlameAudio.bgm.initialize();


    return super.onLoad();
  }

  void playMusic() {
    if (musicEnabled) {
      FlameAudio.bgm.play('music.ogg');
    }
  }

  // void playSound(String sound) {
  //   if (soundsEnabled) {
  //     _soundPlayer.open(
  //       _soundAssets[sound]!,
  //       autoStart: true,
  //       showNotification: false,
  //     );
  //   }
  // }
  //
  // void toggleMusic() {
  //   musicEnabled = !musicEnabled;
  //   if (musicEnabled) {
  //     playMusic();
  //   } else {
  //     FlameAudio.bgm.stop();
  //   }
  // }
  //
  // void toggleSounds() {
  //   soundsEnabled = !soundsEnabled;
  // }
}