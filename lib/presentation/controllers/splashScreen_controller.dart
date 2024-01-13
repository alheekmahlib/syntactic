import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/main/main_screen.dart';

class SplashScreenController extends GetxController {
  Future startTime() async {
    await Future.delayed(const Duration(seconds: 3));
    // if (sl<SharedPreferences>().getBool(IS_FIRST_TIME) == false) {
    Get.off(() => const MainScreen(),
        transition: Transition.downToUp,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut);
    // sl<SharedPreferences>().setBool(IS_FIRST_TIME, false);
    // }
  }
}
