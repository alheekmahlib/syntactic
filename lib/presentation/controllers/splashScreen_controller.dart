import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/main/main_screen.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController get instance =>
      Get.isRegistered<SplashScreenController>()
          ? Get.find<SplashScreenController>()
          : Get.put<SplashScreenController>(SplashScreenController());

  Future startTime() async {
    await Future.delayed(const Duration(seconds: 3));
    // if (sl<SharedPreferences>().getBool(IS_FIRST_TIME) == false) {
    Get.off(() => MainScreen(),
        transition: Transition.downToUp,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut);
    // sl<SharedPreferences>().setBool(IS_FIRST_TIME, false);
    // }
  }
}
