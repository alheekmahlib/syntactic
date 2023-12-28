import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget loading({double? width, double? height}) {
  return Lottie.asset('assets/lottie/splash_loading.json',
      width: width, height: height);
}

Widget playButtonLottie(double? width, double? height) {
  return Lottie.asset('assets/lottie/play_button.json',
      width: width, height: height);
}
