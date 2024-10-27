import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/presentation/screens/whats_new/controller/extensions/whats_new_getters.dart';
import '/presentation/screens/whats_new/controller/whats_new_state.dart';
import '../../../../core/utils/constants/lists.dart';
import '../screen/whats_new_screen.dart';

class WhatsNewController extends GetxController {
  static WhatsNewController get instance =>
      Get.isRegistered<WhatsNewController>()
          ? Get.find<WhatsNewController>()
          : Get.put<WhatsNewController>(WhatsNewController());

  WhatsNewState state = WhatsNewState();

  @override
  void onInit() {
    // state.box.remove(LAST_SHOWN_UPDATE_INDEX);
    navigationPage();
    super.onInit();
  }

  /// -------- [Methods] ----------

  void navigationPage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<Map<String, dynamic>> newFeatures = getNewFeatures();
      if (newFeatures.isNotEmpty) {
        Future.delayed(Duration(seconds: 3)).then((_) => Get.bottomSheet(
              WhatsNewScreen(
                newFeatures: newFeatures,
              ),
              isScrollControlled: true,
              enableDrag: false,
            ));
      }
    });
  }

  List<Map<String, dynamic>> getNewFeatures() {
    int lastShownIndex = getLastShownIndex();

    List<Map<String, dynamic>> newFeatures = whatsNewList.where((item) {
      return item['index'] > lastShownIndex;
    }).toList();

    return newFeatures;
  }

  void showWhatsNew() {
    List<Map<String, dynamic>> newFeatures = getNewFeatures();
    if (newFeatures.isNotEmpty) {
      saveLastShownIndex(newFeatures.last['index']);
    }
  }
}
