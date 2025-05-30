import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/services_locator.dart';

class SettingsController extends GetxController {
  static SettingsController get instance =>
      Get.isRegistered<SettingsController>()
          ? Get.find<SettingsController>()
          : Get.put(SettingsController());
  Locale? initialLang;
  RxString languageName = 'العربية'.obs;
  // RxString languageFont2 = 'kufi'.obs;
  RxBool settingsSelected = false.obs;

  void setLocale(Locale value) {
    initialLang = value;
    update();
  }

  Future<void> loadLang() async {
    String? langCode = sl<SharedPreferences>().getString("lang");
    String? langName = sl<SharedPreferences>().getString("lang_name");

    log('Lang code: $langCode');

    if (langCode == null || langCode.isEmpty) {
      initialLang = const Locale('ar', 'AE');
    } else {
      initialLang = Locale(
          langCode, ''); // Make sure langCode is not null or invalid here
    }

    if (langName != null) {
      languageName.value = langName;
    }

    log('get lang $initialLang');
  }

  List languageList = [
    {
      'lang': 'ar',
      'appLang': 'لغة التطبيق',
      'name': 'العربية',
      'font': 'naskh',
      'font2': 'kufi'
    },
    {
      'lang': 'en',
      'appLang': 'App Language',
      'name': 'English',
      'font': 'naskh',
      'font2': 'naskh'
    },
    {
      'lang': 'bn',
      'appLang': 'অ্যাপের ভাষা',
      'name': 'বাংলা',
      'font': 'bn',
      'font2': 'bn'
    },
    // {
    //   'lang': 'es',
    //   'appLang': 'Idioma de la aplicación',
    //   'name': 'Español',
    //   'font': 'naskh',
    //   'font2': 'naskh'
    // },
    // {
    //   'lang': 'ur',
    //   'appLang': 'ایپ کی زبان',
    //   'name': 'اردو',
    //   'font': 'urdu',
    //   'font2': 'urdu'
    // },
    // {
    //   'lang': 'so',
    //   'appLang': 'Luqadda Appka',
    //   'name': 'Soomaali',
    //   'font': 'naskh'
    // },
  ];
}
