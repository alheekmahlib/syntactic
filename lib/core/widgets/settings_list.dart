import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../presentation/screens/ourApp/ourApps_screen.dart';
import '../utils/constants/svg_picture.dart';
import 'language_list.dart';
import 'theme_change.dart';
import 'white_container.dart';
import 'widgets.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Column(
        children: [
          Container(
            width: orientation(context, width, 381.0),
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(.7),
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
            width: orientation(context, width, 381.0),
            margin:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(.7),
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
                WhiteContainer(myWidget: const ThemeChange(), width: width)
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.onSurface.withOpacity(.7),
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
                              child: alheekmah_logo(context,
                                  width: 60.0,
                                  color:
                                      Theme.of(context).colorScheme.surface)),
                          vDivider(context),
                          Expanded(
                            flex: 8,
                            child: Text(
                              'ourApps'.tr,
                              style: TextStyle(
                                fontFamily: 'kufi',
                                fontSize: 16,
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
        ],
      ),
    ));
  }
}
