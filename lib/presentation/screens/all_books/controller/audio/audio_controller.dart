import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '/presentation/screens/all_books/controller/audio/extensions/audio_getters.dart';
import '../books_controller.dart';
import 'audio_state.dart';

class AudioController extends GetxController {
  static AudioController get instance => Get.isRegistered<AudioController>()
      ? Get.find<AudioController>()
      : Get.put(AudioController());

  final bookCtrl = AllBooksController.instance;
  AudioState state = AudioState();

  @override
  Future<void> onInit() async {
    super.onInit();
    createPlayList();
    await subscribeToPlayerState();
    createPlayList();
  }

  @override
  void onClose() {
    state.audioPlayer.dispose();
    state.audioPlayer.pause();
    state.playerStateSubscription!.cancel();
    super.onClose();
  }

  late final chapterList = ConcatenatingAudioSource(
    // Start loading next item just before reaching it
    useLazyPreparation: true,
    // Customise the shuffle algorithm
    shuffleOrder: DefaultShuffleOrder(),
    // Specify the playlist items
    children: state.chaptersPlayList!,
  );

  void createPlayList() {
    state.chaptersPlayList = List.generate(poemLength, (i) {
      state.poemNumber.value = i + 1;
      return AudioSource.uri(
        Uri.parse(fileUrl),
      );
    });
    log('createPlayList: $fileUrl');
  }

  Future<void> changeAudioSource() async {
    log('changeAudioSource: $fileUrl');
    await state.audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(fileUrl)));
  }

  Future<void> subscribeToPlayerState() async {
    state.playerStateSubscription =
        state.audioPlayer.playerStateStream.listen((playerState) async {
      if (playerState.processingState == ProcessingState.completed) {
        if (bookCtrl.state.chapterNumber.value == lastChapter) {
          await state.audioPlayer.stop();
        } else {
          await seekToNextPoem();
        }
      }
    });
  }

  Future<void> seekToNextPoem() async {
    if (bookCtrl.state.bookNumber.value - 1 == 0 &&
        state.poemNumber.value == lastPoemIn - 3) {
      await state.audioPlayer.stop();
    } else if (state.poemNumber.value == lastPoemIn) {
      await state.audioPlayer.stop();
    } else if (state.poemNumber.value == poemLength) {
      moveToNextPage;
      // createPlayList();
      state.poemNumber.value += 1;
      bookCtrl.state.chapterNumber.value += 1;
      bookCtrl.state.selectedPoemIndex.value = 0;
      await changeAudioSource()
          .then((_) async => await state.audioPlayer.play());
    } else {
      state.poemNumber.value += 1;
      bookCtrl.state.selectedPoemIndex.value += 1;
      await state.audioPlayer.seekToNext();
      await changeAudioSource()
          .then((_) async => await state.audioPlayer.seekToNext());
    }
  }

  Future<void> seekToPrevious() async {
    if (state.poemNumber.value <= firstPoem) {
      moveToPreviousPage;
      // createPlayList();
      state.poemNumber.value -= 1;
      bookCtrl.state.chapterNumber.value -= 1;
      bookCtrl.state.selectedPoemIndex.value = poemLength - 1;
      await changeAudioSource()
          .then((_) async => await state.audioPlayer.play());
    } else {
      state.poemNumber.value -= 1;
      bookCtrl.state.selectedPoemIndex.value -= 1;
      await state.audioPlayer.seekToPrevious();
      await changeAudioSource()
          .then((_) async => await state.audioPlayer.seekToPrevious());
    }
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // state.audioPlayer.pause();
    }
    //print('state = $state');
  }
}
