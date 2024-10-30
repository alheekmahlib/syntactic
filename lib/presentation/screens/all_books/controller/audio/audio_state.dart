import 'dart:async';

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../../core/widgets/seek_bar.dart';

class AudioState {
  /// -------- [Variables] ----------
  RxInt position = RxInt(0);
  ArabicNumbers arabicNumber = ArabicNumbers();
  AudioPlayer audioPlayer = AudioPlayer();
  RxBool isPlaying = false.obs;
  RxInt poemNumber = 1.obs;
  List<AudioSource>? chaptersPlayList;
  Rx<PositionData>? positionData;
  var activeButton = RxString('');
  RxDouble audioWidgetPosition = (-240.0).obs;
  StreamSubscription<PlayerState>? playerStateSubscription;
  double poemHeight = 90.0;
}
