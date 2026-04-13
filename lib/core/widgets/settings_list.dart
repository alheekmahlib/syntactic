import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../presentation/screens/ourApp/screen/our_apps_screen.dart';
import '../utils/constants/svg_constants.dart';
import '../utils/helpers/app_text_styles.dart';
import 'about_app.dart';
import 'language_list.dart';
import 'theme_change.dart';
import 'white_container.dart';
import 'widgets.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: Get.height,
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              width: Get.width,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: .7),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  )),
              child: Column(
                children: [
                  Text(
                    'appLang'.tr,
                    style: AppTextStyles.heading2(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const LanguageList(),
                ],
              ),
            ),
            Container(
              width: context.customOrientation(Get.width, 381.0),
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: .7),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  )),
              child: Column(
                children: [
                  Text(
                    'changeTheme'.tr,
                    style: AppTextStyles.heading2(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  WhiteContainer(myWidget: ThemeChange(), width: Get.width)
                ],
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 2.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: .7),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4.0),
                      )),
                  child: WhiteContainer(
                    myWidget: InkWell(
                      child: SizedBox(
                        height: 45,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: customSvgWithColor(
                                    SvgPath.svgAlheekmahLogo,
                                    width: 60.0,
                                    color:
                                        Theme.of(context).colorScheme.surface)),
                            vDivider(context),
                            Expanded(
                              flex: 8,
                              child: Text(
                                'ourApps'.tr,
                                style: AppTextStyles.heading3(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Theme.of(context).colorScheme.surface,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.to(() => const OurApps(),
                            transition: Transition.downToUp);
                      },
                    ),
                  ),
                )),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 2.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: .7),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4.0),
                      )),
                  child: WhiteContainer(
                    myWidget: InkWell(
                      child: SizedBox(
                        height: 45,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: customSvgWithColor(
                                  SvgPath.svgSyntacticR,
                                  height: 35.0,
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                            vDivider(context),
                            Expanded(
                              flex: 8,
                              child: Text(
                                'aboutApp'.tr,
                                style: AppTextStyles.heading3(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Theme.of(context).colorScheme.surface,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.to(() => const AboutApp(),
                            transition: Transition.downToUp);
                      },
                    ),
                  ),
                )),
          ],
        )),
      ),
    );
  }
}
