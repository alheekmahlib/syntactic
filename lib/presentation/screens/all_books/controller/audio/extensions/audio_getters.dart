import 'package:flutter/animation.dart';
import 'package:rxdart/rxdart.dart' as rx;

import '/presentation/screens/all_books/controller/audio/audio_controller.dart';
import '/presentation/screens/all_books/controller/extensions/books_getters.dart';
import '../../../../../../core/utils/constants/constants.dart';
import '../../../../../../core/widgets/seek_bar.dart';

extension AudioGetters on AudioController {
  String get fileUrl =>
      '${Constants.audioUrl}${bookCtrl.state.bookNumber}/${bookCtrl.state.chapterNumber.value + 1}/${state.poemNumber.value}.mp3';

  int get poemLength => bookCtrl.currentPoemBook!
      .chapters![bookCtrl.state.chapterNumber.value].poems!.last.poemNumber!;

  int get firstPoem => bookCtrl.currentPoemBook!
      .chapters![bookCtrl.state.chapterNumber.value].poems!.first.poemNumber!;

  int get lastChapter => bookCtrl.currentPoemBook!.chapters!.length;

  void get moveToNextPage => bookCtrl.state.pPageController.animateToPage(
      bookCtrl.state.chapterNumber.value + 1,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut);

  void get moveToPreviousPage => bookCtrl.state.pPageController.animateToPage(
      bookCtrl.state.chapterNumber.value - 1,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut);

  Stream<PositionData> get positionDataStream =>
      rx.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          state.audioPlayer.positionStream,
          state.audioPlayer.bufferedPositionStream,
          state.audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
}
