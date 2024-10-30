import 'dart:async';
import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/services/connectivity_service.dart';
import '../data/models/ourApp_model.dart';

class OurAppsController extends GetxController {
  static OurAppsController get instance => Get.isRegistered<OurAppsController>()
      ? Get.find<OurAppsController>()
      : Get.put(OurAppsController());

  RxString errorMessage = "".obs;

  Future<List<OurAppInfo>> fetchApps() async {
    try {
      if (ConnectivityService.instance.noConnection.value) {
        throw Exception('No internet connection');
      } else {
        final response = await http.get(Uri.parse(
            'https://raw.githubusercontent.com/alheekmahlib/thegarlanded/master/ourApps.json'));

        if (response.statusCode == 200) {
          List<dynamic> jsonData = jsonDecode(response.body);
          return jsonData.map((data) => OurAppInfo.fromJson(data)).toList();
        } else {
          throw Exception('Failed to load data');
        }
      }
    } catch (e) {
      errorMessage.value =
          'تعذر جلب التطبيقات. يرجى التحقق من اتصال الإنترنت والمحاولة مجددًا.';
      return []; // إرجاع قائمة فارغة لتفادي تعطل التطبيق
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
      } else if (Theme.of(context).platform == TargetPlatform.android) {
        final deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

        if (androidInfo.manufacturer.toLowerCase() != 'huawei') {
          if (await canLaunchUrl(Uri.parse(ourAppInfo.urlPlayStore))) {
            await launchUrl(Uri.parse(ourAppInfo.urlPlayStore));
          } else {
            throw 'Could not launch ${ourAppInfo.urlPlayStore}';
          }
        } else {
          if (await canLaunchUrl(Uri.parse(ourAppInfo.urlAppGallery))) {
            await launchUrl(Uri.parse(ourAppInfo.urlAppGallery));
          } else {
            throw 'Could not launch ${ourAppInfo.urlAppGallery}';
          }
        }
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
