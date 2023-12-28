import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/services_locator.dart';
import '../../core/utils/constants/lists.dart';
import '../../core/utils/helpers/languages/app_constants.dart';
import '../screens/home/data/models/time_now.dart';

class GeneralController extends GetxController {
  RxInt selected = 0.obs;
  RxString greeting = ''.obs;
  TimeNow timeNow = TimeNow();
  RxBool isExpanded = false.obs;
  RxDouble fontSizeArabic = 17.0.obs;
  PageController controller = PageController();
  GlobalKey<SliderDrawerState> key = GlobalKey<SliderDrawerState>();
  final ArabicNumbers arabicNumbers = ArabicNumbers();
  final prefs = sl<SharedPreferences>();

  String get currentLang => prefs.getString(AppConstants.LANGUAGE_CODE) ?? 'ar';
  Future<void> setCurrentlang(String newLangCode) async =>
      await prefs.setString(AppConstants.LANGUAGE_CODE, newLangCode);

  /// Greeting
  updateGreeting() {
    final now = DateTime.now();
    final isMorning = now.hour < 12;
    greeting.value = isMorning ? 'morning'.tr : 'evening'.tr;
  }

  String convertNumbers(String inputStr) {
    Map<String, Map<String, String>> numberSets = {
      'العربية': {
        '0': '٠',
        '1': '١',
        '2': '٢',
        '3': '٣',
        '4': '٤',
        '5': '٥',
        '6': '٦',
        '7': '٧',
        '8': '٨',
        '9': '٩',
      },
      'English': {
        '0': '0',
        '1': '1',
        '2': '2',
        '3': '3',
        '4': '4',
        '5': '5',
        '6': '6',
        '7': '7',
        '8': '8',
        '9': '9',
      },
      'বাংলা': {
        '0': '০',
        '1': '১',
        '2': '২',
        '3': '৩',
        '4': '৪',
        '5': '৫',
        '6': '৬',
        '7': '৭',
        '8': '৮',
        '9': '৯',
      },
      'اردو': {
        '0': '۰',
        '1': '۱',
        '2': '۲',
        '3': '۳',
        '4': '۴',
        '5': '۵',
        '6': '۶',
        '7': '۷',
        '8': '۸',
        '9': '۹',
      },
    };

    Map<String, String>? numSet = numberSets['lang'.tr];

    if (numSet == null) {
      return inputStr;
    }

    for (var entry in numSet.entries) {
      inputStr = inputStr.replaceAll(entry.key, entry.value);
    }

    return inputStr;
  }

  bool isRtlLanguage(String languageName) {
    return rtlLang.contains(languageName);
  }

  checkRtlLayout(var rtl, var ltr) {
    if (isRtlLanguage('lang'.tr)) {
      return rtl;
    } else {
      return ltr;
    }
  }

  RotatedBox checkWidgetRtlLayout(Widget myWidget) {
    if (isRtlLanguage('lang'.tr)) {
      return RotatedBox(quarterTurns: 0, child: myWidget);
    } else {
      return RotatedBox(quarterTurns: 2, child: myWidget);
    }
  }

  FloatingActionButtonLocation checkFloatingRtlLayout() {
    if (isRtlLanguage('lang'.tr)) {
      return FloatingActionButtonLocation.startDocked;
    } else {
      return FloatingActionButtonLocation.endDocked;
    }
  }

  String copyHadith(String bookName, String bookOtherName, String chapterName,
      int hadithNumber) {
    return '''$bookName\n'''
        '''$bookOtherName\n'''
        '''$chapterName\n\n'''
        '''تجربة\n'''
        '''رقم الحديث: $hadithNumber''';
  }

  String copyHadithWithTranslate(String arAndEnName, String bookOtherName,
      String chapterName, int hadithNumber) {
    return '''$arAndEnName\n'''
        '''$bookOtherName\n'''
        '''$chapterName\n\n'''
        '''تجربة\n'''
        '''رقم الحديث: $hadithNumber\n\n'''
        '''${'translationOfHadith'.tr}\n'''
        '''test\n'''
        '''${'hadithNumber'.tr}: $hadithNumber''';
  }
}
