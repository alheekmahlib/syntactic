import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_constants.dart';
import 'language_models.dart';
import 'localization_controller.dart';

Future<Map<String, Map<String, String>>> init() async {
  final sharedPreference = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreference);
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));

  Map<String, Map<String, String>> languages = {};
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues = await rootBundle
        .loadString('assets/locales/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);

    Map<String, String> jsonData = {};
    mappedJson.forEach((key, value) {
      jsonData[key] = value.toString();
    });

    languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        jsonData;
  }
  return languages;
}
