import 'package:flutter/material.dart';

import '/presentation/screens/all_books/controller/audio/extensions/audio_getters.dart';
import '../../../../../core/widgets/seek_bar.dart';
import '../../controller/audio/audio_controller.dart';

class SeekBarWidget extends StatelessWidget {
  SeekBarWidget({super.key});

  final audioCtrl = AudioController.instance;

  @override
  Widget build(BuildContext context) {
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
            onChangeEnd: audioCtrl.state.audioPlayer.seek,
          );
        },
      ),
    );
  }
}
