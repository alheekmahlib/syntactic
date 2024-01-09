import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/utils/constants/svg_picture.dart';
import '../../../controllers/audio_controller.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    final audioCtrl = sl<AudioController>();
    return StreamBuilder<PlayerState>(
      stream: audioCtrl.audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return playButtonLottie(20.0, 20.0);
        } else if (playing != true) {
          return GestureDetector(
            onTap: () async {
              await audioCtrl.audioPlayer.play();
            },
            child: play_logo(context, height: 24),
          );
        } else {
          return GestureDetector(
            child: Icon(
              Icons.pause,
              size: 24.0,
              color: Theme.of(context).colorScheme.primary,
            ),
            onTap: () {
              audioCtrl.audioPlayer.pause();
            },
          );
        }
      },
    );
  }
}
