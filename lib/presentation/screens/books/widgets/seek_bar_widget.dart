import 'package:flutter/material.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/widgets/seek_bar.dart';
import '../../../controllers/audio_controller.dart';

class SeekBarWidget extends StatelessWidget {
  const SeekBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final audioCtrl = sl<AudioController>();
    return Container(
      height: 30,
      alignment: Alignment.center,
      child: StreamBuilder<PositionData>(
        stream: audioCtrl.positionDataStream,
        builder: (context, snapshot) {
          final positionData = snapshot.data;
          return SeekBar(
            timeShow: true,
            textColor: Theme.of(context).colorScheme.secondary,
            duration: positionData?.duration ?? Duration.zero,
            position: positionData?.position ?? Duration.zero,
            bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
            activeTrackColor: Theme.of(context).colorScheme.secondary,
            onChangeEnd: audioCtrl.audioPlayer.seek,
          );
        },
      ),
    );
  }
}
