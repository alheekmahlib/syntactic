import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/constants/svg_constants.dart';

/// Usage Example
/// final connectivityService = Get.put(ConnectivityService());
/// await connectivityService.init();
/// Now you can use connectivityService.connectionStatus
/// or connectivityService.noConnection.
/// OR
/// ConnectivityService.instance.init();
/// Now you can use ConnectivityService.instance.connectionStatus
/// or ConnectivityService.instance.noConnection.

class ConnectivityService extends GetxService {
  static ConnectivityService get instance =>
      Get.isRegistered<ConnectivityService>()
          ? Get.find<ConnectivityService>()
          : Get.put(ConnectivityService());

  /// -------- [ConnectivityService] ----------

  /// -------- [Variables] ----------

  final RxList<ConnectivityResult> _connectionStatus =
      [ConnectivityResult.none].obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  /// متغير يحدد إذا كان هناك اتصال بالإنترنت أم لا (يتم تحديثه تلقائياً)
  /// RxBool that indicates if there is no internet connection (auto-updated)
  final RxBool noConnection = true.obs;

  /// -------- [Getter] ----------

  RxList<ConnectivityResult> get connectionStatus => _connectionStatus;

  /// -------- [Initialization] ----------

  Future<ConnectivityService> init() async {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    await _initConnectivity();
    return this;
  }

  /// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    _connectionStatus.value = result;
    // تحديث حالة الاتصال
    // Update noConnection state
    noConnection.value = result.contains(ConnectivityResult.none);
    log('Connectivity changed: $_connectionStatus');
    // _showConnectivityStatusSnackBar(result);
  }

  // void _showConnectivityStatusSnackBar(List<ConnectivityResult> result) {
  //   if (result.contains(ConnectivityResult.none)) {
  //     Get.context?.showCustomErrorSnackBar('noInternet'.tr);
  //   } else if (result.contains(ConnectivityResult.mobile)) {
  //     Get.context?.showCustomErrorSnackBar('mobileDataAyat'.tr);
  //   }
  // }

  /// -------- [Dispose] ----------

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  /// -------- [No Internet Widget] ----------

  Widget get noInternetWidget => Column(
        children: [
          const Gap(60),
          Get.context?.customSvg(SvgPath.svgAlert, height: 120) ??
              const SizedBox(),
          const Gap(16),
          Text(
            'noInternet'.tr,
            style: TextStyle(
              color: Get.theme.colorScheme.surface,
              fontFamily: 'kufi',
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
}
