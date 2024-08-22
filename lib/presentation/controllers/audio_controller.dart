import 'dart:async';
import 'dart:developer';

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rx;

import '/core/utils/constants/constants.dart';
import '/presentation/controllers/books_controller.dart';
import '../../core/services/services_locator.dart';
import '../../core/widgets/seek_bar.dart';

class AudioController extends GetxController {
  RxInt position = RxInt(0);
  ArabicNumbers arabicNumber = ArabicNumbers();
  final bool isDisposed = false;
  AudioPlayer audioPlayer = AudioPlayer();
  RxBool isPlaying = false.obs;
  RxInt poemNumber = 1.obs;
  List<ConnectivityResult> connectionStatus = [ConnectivityResult.none];
  final Connectivity connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;
  List<AudioSource>? chaptersPlayList;
  Rx<PositionData>? positionData;
  var activeButton = RxString('');
  RxDouble audioWidgetPosition = (-240.0).obs;
  final bookCtrl = sl<BooksController>();
  StreamSubscription<PlayerState>? playerStateSubscription;
  double poemHeight = 90.0;

  late final chapterList = ConcatenatingAudioSource(
    // Start loading next item just before reaching it
    useLazyPreparation: true,
    // Customise the shuffle algorithm
    shuffleOrder: DefaultShuffleOrder(),
    // Specify the playlist items
    children: chaptersPlayList!,
  );

  createPlayList() {
    final bookCtrl = sl<BooksController>();
    int poemLength = bookCtrl
        .currentPoemBook!.chapters![bookCtrl.chapterNumber.value].poems!.length;
    chaptersPlayList = List.generate(poemLength, (i) {
      poemNumber.value = i + 1;
      return AudioSource.uri(
        Uri.parse(
            '${Constants.audioUrl}${bookCtrl.bookNumber}/${bookCtrl.chapterNumber.value + 1}/${poemNumber.value}.mp3'),
      );
    });
    log('${Constants.audioUrl}${bookCtrl.bookNumber}/${bookCtrl.chapterNumber.value}/${poemNumber.value}.mp3');
  }

  Future<void> changeAudioSource(int chapterNumber, int poemNumber) async {
    log('changeAudioSource: ${Constants.audioUrl}${bookCtrl.bookNumber}/${chapterNumber + 1}/$poemNumber.mp3');
    await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(
        '${Constants.audioUrl}${bookCtrl.bookNumber}/${chapterNumber + 1}/$poemNumber.mp3')));
  }

  Future<void> subscribeToPlayerState() async {
    int poemLength = bookCtrl.currentPoemBook!
        .chapters![bookCtrl.chapterNumber.value].poems!.last.poemNumber!;
    playerStateSubscription =
        audioPlayer.playerStateStream.listen((playerState) async {
      if (playerState.processingState == ProcessingState.completed) {
        if (poemNumber.value >= poemLength) {
          await audioPlayer.stop();
        } else {
          // poemNumber.value += 1;
          bookCtrl.selectedPoemIndex.value += 1;
          await audioPlayer.seekToNext();
          await changeAudioSource(
              bookCtrl.chapterNumber.value, poemNumber.value += 1);
          // sl<BooksController>().scrollController.animateTo(
          //     (poemNumber.value).toDouble() * poemHeight,
          //     duration: const Duration(milliseconds: 600),
          //     curve: Curves.easeInOut);
        }
      }
    });
  }

  Future<void> seekToNextPoem() async {
    int poemLength = bookCtrl.currentPoemBook!
        .chapters![bookCtrl.chapterNumber.value].poems!.last.poemNumber!;
    if (poemNumber.value >= poemLength) {
      await audioPlayer.stop();
    } else {
      // poemNumber.value += 1;
      bookCtrl.selectedPoemIndex.value += 1;
      await audioPlayer.seekToNext();
      await changeAudioSource(
          bookCtrl.chapterNumber.value, poemNumber.value += 1);
      // await sl<BooksController>().scrollController.animateTo(
      //       (poemNumber.value).toDouble() * poemHeight,
      //       duration: const Duration(milliseconds: 600),
      //       curve: Curves.easeInOut,
      //     );
    }
  }

  Future<void> seekToPrevious() async {
    int firstPoem = bookCtrl.currentPoemBook!
        .chapters![bookCtrl.chapterNumber.value].poems!.first.poemNumber!;
    if (poemNumber.value <= firstPoem) {
      await audioPlayer.stop();
    } else {
      poemNumber.value -= 1;
      bookCtrl.selectedPoemIndex.value -= 1;
      await audioPlayer.seekToPrevious();
      changeAudioSource(bookCtrl.chapterNumber.value, poemNumber.value);
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    sl<BooksController>().loadPoemBooks ? createPlayList() : null;
    connectivitySubscription =
        connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initConnectivity();
    sl<BooksController>().loadPoemBooks ? await subscribeToPlayerState() : null;
  }

  Stream<PositionData> get positionDataStream =>
      rx.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  void onClose() {
    audioPlayer.dispose();
    connectivitySubscription.cancel();
    audioPlayer.pause();
    playerStateSubscription!.cancel();
    super.onClose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      audioPlayer.pause();
    }
    //print('state = $state');
  }

  /// -------- [ConnectivityMethods] ----------

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (isDisposed) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    connectionStatus = result;
    update();
    // ignore: avoid_log(message)
    log('Connectivity changed: $connectionStatus');
  }
}
