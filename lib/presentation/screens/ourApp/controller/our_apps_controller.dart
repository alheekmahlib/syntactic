import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/constants/api_constants.dart';
import '../../../../core/utils/helpers/api_client.dart';
import '../data/models/our_app_model.dart';

class OurAppsController extends GetxController {
  static OurAppsController get instance => Get.isRegistered<OurAppsController>()
      ? Get.find<OurAppsController>()
      : Get.put(OurAppsController());

  RxString errorMessage = "".obs;

  Future<List<OurAppInfo>> fetchApps() async {
    try {
      final response = await ApiClient().request(
        endpoint: ApiConstants.ourAppsUrl,
        method: HttpMethod.get,
      );

      if (response.isRight) {
        // إذا كانت الاستجابة صحيحة، قم بتحليل البيانات
        // If the response is successful, parse the data
        List<dynamic> jsonData = jsonDecode(response.right as String);
        return jsonData.map((data) => OurAppInfo.fromJson(data)).toList();
      } else {
        // إذا كانت الاستجابة خاطئة، قم بتسجيل الخطأ
        // If the response is an error, log the error
        log('Failed to load data: ${response.left.message}',
            name: 'OurAppsController');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // تسجيل أي استثناء يحدث
      // Log any exception that occurs
      log('Error occurred: $e', name: 'OurAppsController');
      throw Exception('Failed to load data');
    }
  }

  Future<void> launchURL(
      BuildContext context, int index, OurAppInfo ourAppInfo) async {
    if (!kIsWeb) {
      final Uri uri =
          Uri.parse(ApiConstants.downloadAppUrl + ourAppInfo.appName);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch ${ApiConstants.downloadAppUrl + ourAppInfo.appName}';
      }
    }
  }
}
