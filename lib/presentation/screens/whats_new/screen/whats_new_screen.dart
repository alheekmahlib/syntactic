import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/presentation/screens/whats_new/controller/extensions/whats_new_getters.dart';
import '../../../controllers/general_controller.dart';
import '../controller/whats_new_controller.dart';
import '../screen/widgets/button_widget.dart';
import '../screen/widgets/page_view_build.dart';
import '../screen/widgets/smooth_page_indicator.dart';
import '../screen/widgets/whats_new_widget.dart';

class WhatsNewScreen extends StatelessWidget {
  final List<Map<String, dynamic>> newFeatures;
  WhatsNewScreen({super.key, required this.newFeatures});

  final controller = PageController(viewportFraction: 1, keepPage: true);
  final whatsNewCtrl = WhatsNewController.instance;
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
        height: size.height * .94,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8),
              topLeft: Radius.circular(8),
            )),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Text(
                      'skip'.tr,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 12.0.sp,
                        fontFamily: 'kufi',
                      ),
                    ),
                    onTap: () {
                      Get.back();
                      whatsNewCtrl
                          .saveLastShownIndex(newFeatures.last['index']);
                    },
                  ),
                  SmoothPageIndicatorWidget(
                    controller: controller,
                    newFeatures: newFeatures,
                  ),
                ],
              ),
              const Gap(16),
              const WhatsNewWidget(),
              PageViewBuild(
                controller: controller,
                newFeatures: newFeatures,
              ),
              ButtonWidget(
                controller: controller,
                newFeatures: newFeatures,
              ),
            ],
          ),
        ));
  }
}
