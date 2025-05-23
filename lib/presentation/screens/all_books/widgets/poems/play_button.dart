import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/constants/svg_constants.dart';
import '../../../../../core/utils/constants/lottie.dart';
import '../../controller/audio/audio_controller.dart';

class PlayButton extends StatelessWidget {
  PlayButton({super.key});

  final audioCtrl = AudioController.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audioCtrl.state.audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return playButtonLottie(20.0, 20.0);
        } else if (playing != true) {
          return GestureDetector(
            onTap: () async => await audioCtrl.togglePlayPause(),
            child: customSvgWithColor(SvgPath.svgPlay,
                height: 24, color: context.theme.colorScheme.surface),
          );
        } else {
          return GestureDetector(
            child: Icon(
              Icons.pause,
              size: 24.0,
              color: Theme.of(context).colorScheme.surface,
            ),
            onTap: () async => await audioCtrl.togglePlayPause(),
          );
        }
      },
    );
  }
}
