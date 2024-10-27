import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nahawi/core/utils/constants/extensions/svg_extensions.dart';
import 'package:nahawi/core/utils/constants/svg_constants.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../controller/audio/audio_controller.dart';
import 'play_button.dart';
import 'seek_bar_widget.dart';

class AudioWidget extends StatelessWidget {
  AudioWidget({super.key});

  final audioCtrl = AudioController.instance;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 90,
        width: 350,
        margin: const EdgeInsets.all(32),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(17))),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: customClose(
                  context,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 40.0),
                      child: StreamBuilder<LoopMode>(
                        stream: audioCtrl.state.audioPlayer.loopModeStream,
                        builder: (context, snapshot) {
                          final loopMode = snapshot.data ?? LoopMode.off;
                          List<Widget> icons = [
                            Icon(
                              Icons.repeat,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(.4),
                              size: 18,
                            ),
                            Icon(
                              Icons.repeat,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 18,
                            ),
                          ];
                          const cycleModes = [
                            LoopMode.off,
                            LoopMode.all,
                          ];
                          final index = cycleModes.indexOf(loopMode);
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: GestureDetector(
                              child: icons[index],
                              onTap: () {
                                audioCtrl.state.audioPlayer.setLoopMode(
                                    cycleModes[
                                        (cycleModes.indexOf(loopMode) + 1) %
                                            cycleModes.length]);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 28,
                      width: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          )),
                      child: Obx(() {
                        return Text(
                          audioCtrl.state.poemNumber.value.toString(),
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'naskh',
                            color: Colors.black,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  width: 250,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      customSvg(SvgPath.svgPlayBackgraond, height: 50),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await audioCtrl.seekToPrevious();
                            },
                            child: customSvg(SvgPath.svgNextArrow, height: 24),
                          ),
                          const Gap(20),
                          PlayButton(),
                          const Gap(20),
                          GestureDetector(
                            onTap: () async {
                              await audioCtrl.seekToNextPoem();
                            },
                            child: RotatedBox(
                              quarterTurns: 90,
                              child:
                                  customSvg(SvgPath.svgNextArrow, height: 24),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SeekBarWidget()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
