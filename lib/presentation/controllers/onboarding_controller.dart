import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/services_locator.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../screens/onboarding/screen/onboarding_screen.dart';

class OnboardingController extends GetxController {
  final controller = PageController(viewportFraction: 1, keepPage: true);
  RxInt pageNumber = 1.obs;
  double indicatorProgress = .0;
  bool progress = true;

  indicator(int pageNumber) {
    if (pageNumber == 0) {
      indicatorProgress = .0;
    } else if (pageNumber == 1) {
      indicatorProgress = .33;
    } else if (pageNumber == 2) {
      indicatorProgress = .66;
    } else if (pageNumber == 3) {
      indicatorProgress = 1.0;
    }
  }

  Future<void> startOnboarding() async {
    print('is_first_time ${sl<SharedPreferences>().getBool("is_first_time")}');
    if (sl<SharedPreferences>().getBool(IS_FIRST_TIME) == null) {
      await Future.delayed(const Duration(seconds: 2));
      Get.bottomSheet(
        OnboardingScreen(),
        isScrollControlled: true,
      );
      sl<SharedPreferences>().setBool(IS_FIRST_TIME, false);
    }
  }
}
