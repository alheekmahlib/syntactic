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

  launchURL(BuildContext context, int index, OurAppInfo ourAppInfo) async {
    if (!kIsWeb) {
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        if (await canLaunchUrl(Uri.parse(ourAppInfo.urlAppStore))) {
          await launchUrl(Uri.parse(ourAppInfo.urlAppStore));
        } else {
          throw 'Could not launch ${ourAppInfo.urlAppStore}';
        }
        // } else if (Theme.of(context).platform == TargetPlatform.android) {
        //   final deviceInfo = DeviceInfoPlugin();
        //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

        //   if (androidInfo.manufacturer.toLowerCase() != 'huawei') {
        //     if (await canLaunchUrl(Uri.parse(ourAppInfo.urlPlayStore))) {
        //       await launchUrl(Uri.parse(ourAppInfo.urlPlayStore));
        //     } else {
        //       throw 'Could not launch ${ourAppInfo.urlPlayStore}';
        //     }
      } else {
        if (await canLaunchUrl(Uri.parse(ourAppInfo.urlAppGallery))) {
          await launchUrl(Uri.parse(ourAppInfo.urlAppGallery));
        } else {
          throw 'Could not launch ${ourAppInfo.urlAppGallery}';
        }
        // }
      }
    } else {
      if (await canLaunchUrl(Uri.parse(ourAppInfo.urlMacAppStore))) {
        await launchUrl(Uri.parse(ourAppInfo.urlMacAppStore));
      } else {
        throw 'Could not launch ${ourAppInfo.urlMacAppStore}';
      }
    }
  }
}
