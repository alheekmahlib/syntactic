import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahawi/core/utils/constants/extensions/svg_extensions.dart';

import '/core/utils/constants/extensions.dart';
import '../../presentation/screens/ourApp/ourApps_screen.dart';
import '../utils/constants/svg_constants.dart';
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
        height: platformView(
            orientation(
                context, Get.height / 1 / 2 * 1.1, Get.height / 1 / 2 * 1.5),
            Get.height / 1 / 2 * 1.1),
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Column(
            children: [
              Container(
                width: context.customOrientation(Get.width, 381.0),
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.onSurface.withOpacity(.7),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    )),
                child: Column(
                  children: [
                    Text(
                      'appLang'.tr,
                      style: TextStyle(
                        fontFamily: 'kufi',
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const LanguageList(),
                  ],
                ),
              ),
              Container(
                width: context.customOrientation(Get.width, 381.0),
                margin: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.onSurface.withOpacity(.7),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    )),
                child: Column(
                  children: [
                    Text(
                      'changeTheme'.tr,
                      style: TextStyle(
                        fontFamily: 'kufi',
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    WhiteContainer(
                        myWidget: const ThemeChange(), width: Get.width)
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 2.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 2.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(.7),
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface)),
                              vDivider(context),
                              Expanded(
                                flex: 8,
                                child: Text(
                                  'ourApps'.tr,
                                  style: TextStyle(
                                    fontFamily: 'kufi',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.surface,
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 2.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 2.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(.7),
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
                                  child: customSvg(
                                    SvgPath.svgSyntacticR,
                                    height: 35.0,
                                  )),
                              vDivider(context),
                              Expanded(
                                flex: 8,
                                child: Text(
                                  'aboutApp'.tr,
                                  style: TextStyle(
                                    fontFamily: 'kufi',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.surface,
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
          ),
        )),
      ),
    );
  }
}
