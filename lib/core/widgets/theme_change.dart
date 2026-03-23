import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../core/utils/constants/svg_constants.dart';
import '../../presentation/controllers/theme_controller.dart';

class ThemeChange extends StatelessWidget {
  ThemeChange({super.key});

  final themeCtrl = ThemeController.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            themeCtrl.themeList.length,
            (index) {
              final currentTheme =
                  themeCtrl.themeList[index]['name'] == themeCtrl.currentTheme;
              return GestureDetector(
                onTap: () async {
                  await themeCtrl.setTheme(themeCtrl.themeList[index]['name']);
                  Get.forceAppUpdate().then((_) {
                    Get.back();
                  });
                },
                // value: themeList[index]['name'] == themeCtrl.currentTheme,
                child: Container(
                  height: 60,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: index.isEven
                        ? context.theme.colorScheme.surface
                        : Colors.black87,
                  ),
                  child: Row(
                    children: [
                      currentTheme
                          ? Container(
                              height: 60,
                              width: 4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: context.theme.canvasColor,
                              ),
                            )
                          : SizedBox.shrink(),
                      currentTheme ? Gap(8) : SizedBox.shrink(),
                      customSvgWithCustomColor(
                        SvgPath.svgSyntactic,
                        height: 20,
                        color: Get.theme.canvasColor,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
