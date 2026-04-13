import 'package:floating_menu_expendable/floating_menu_expendable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/helpers/app_text_styles.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../controller/ourApps_controller.dart';
import '../../data/models/ourApp_model.dart';

class AppsInfo extends StatelessWidget {
  final OurAppInfo apps;
  final FloatingMenuAnchoredOverlayController controller;
  const AppsInfo({super.key, required this.apps, required this.controller});

  @override
  Widget build(BuildContext context) {
    final appInfo = OurAppsController.instance;
    return Material(
      color: context.theme.colorScheme.surface.withValues(alpha: 0.2),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Stack(
            children: [
              ListView(
                children: [
                  SvgPicture.network(apps.appLogo, width: 80),
                  const Gap(8.0),
                  Center(
                    child: Text(
                      '| ${apps.appTitle} |',
                      style: AppTextStyles.titleMedium(),
                    ),
                  ),
                  const Divider(
                    height: 16,
                    thickness: 2,
                    endIndent: 16,
                    indent: 16,
                  ),
                  const Gap(8.0),
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: apps.appBanner == ''
                            ? const SizedBox.shrink()
                            : Image.network(
                                apps.appBanner,
                                // height: 400,
                              ),
                      ),
                      const Gap(8.0),
                      _storeButton(
                        context: context,
                        appInfo: appInfo,
                        apps: apps,
                      ),
                    ],
                  ),
                ],
              ),
              customClose(
                context,
                close: () => controller.close(),
                color: context.theme.colorScheme.surface.withValues(alpha: .4),
                color2: context.theme.colorScheme.inversePrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _storeButton({
    required BuildContext context,
    required OurAppsController appInfo,
    required OurAppInfo apps,
  }) {
    return GestureDetector(
      onTap: () => appInfo.launchURL(context, apps),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: context.theme.primaryColorLight.withValues(alpha: .4),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          'download'.tr,
          style: AppTextStyles.titleMedium(
            fontSize: 16.0,
            color: context.theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
