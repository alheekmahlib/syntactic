import 'dart:async';
import 'dart:developer' as developer;

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as R;
import 'package:syntactic/core/utils/constants/constants.dart';
import 'package:syntactic/presentation/controllers/books_controller.dart';

import '../../core/services/services_locator.dart';
import '../../core/widgets/seek_bar.dart';

class AudioController extends GetxController {
  RxInt position = RxInt(0);
  ArabicNumbers arabicNumber = ArabicNumbers();
  final bool _isDisposed = false;
  AudioPlayer audioPlayer = AudioPlayer();
  RxBool isPlaying = false.obs;
  RxInt poemNumber = 1.obs;
  ConnectivityResult connectionStatus = ConnectivityResult.none;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late ConnectivityResult result;
  final _connectivity = Connectivity();
  List<AudioSource>? chaptersPlayList;
  Rx<PositionData>? positionData;
  var activeButton = RxString('');
  RxDouble audioWidgetPosition = (-240.0).obs;
  final bookCtrl = sl<BooksController>();
  StreamSubscription<PlayerState>? playerStateSubscription;

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
        .poem.value!.chapters![bookCtrl.chapterNumber.value].poems!.length;
    chaptersPlayList = List.generate(poemLength, (i) {
      poemNumber.value = i + 1;
      return AudioSource.uri(
        Uri.parse(
            '${Constants.audioUrl}${bookCtrl.bookNumber}/${bookCtrl.chapterNumber.value + 1}/${poemNumber.value}.mp3'),
      );
    });
    print(
        '${Constants.audioUrl}${bookCtrl.bookNumber}/${bookCtrl.chapterNumber.value}/${poemNumber.value}.mp3');
  }

  Future<void> changeAudioSource(int chapterNumber, int poemNumber) async {
    print(
        'changeAudioSource: ${Constants.audioUrl}${bookCtrl.bookNumber}/${chapterNumber + 1}/$poemNumber.mp3');
    await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(
        '${Constants.audioUrl}${bookCtrl.bookNumber}/${chapterNumber + 1}/$poemNumber.mp3')));
  }

  Future<void> subscribeToPlayerState() async {
    int poemLength = bookCtrl.poem.value!
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
        }
      }
    });
  }

  Future<void> seekToNextPoem() async {
    int poemLength = bookCtrl.poem.value!
        .chapters![bookCtrl.chapterNumber.value].poems!.last.poemNumber!;
    if (poemNumber.value >= poemLength) {
      await audioPlayer.stop();
    } else {
      // poemNumber.value += 1;
      bookCtrl.selectedPoemIndex.value += 1;
      await audioPlayer.seekToNext();
      await changeAudioSource(
          bookCtrl.chapterNumber.value, poemNumber.value += 1);
    }
  }

  Future<void> seekToPrevious() async {
    int firstPoem = bookCtrl.poem.value!.chapters![bookCtrl.chapterNumber.value]
        .poems!.first.poemNumber!;
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
    createPlayList();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initConnectivity();
    await subscribeToPlayerState();
  }

  Stream<PositionData> get positionDataStream =>
      R.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  void onClose() {
    audioPlayer.dispose();
    _connectivitySubscription.cancel();
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

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }
    if (_isDisposed) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    connectionStatus = result;
  }
}
