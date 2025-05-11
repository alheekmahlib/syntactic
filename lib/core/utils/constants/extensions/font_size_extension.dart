import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/handler_animation.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nahawi/core/utils/constants/svg_constants.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../../presentation/controllers/general_controller.dart';
import '../shared_preferences_constants.dart';

extension FontSizeExtension on Widget {
  Widget fontSizeDropDown({double? height, Color? color}) {
    final box = GetStorage();
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      icon: Semantics(
        button: true,
        enabled: true,
        label: 'Change Font Size',
        child: Transform.translate(
          offset: const Offset(0, -3),
          child: customSvgWithColor(SvgPath.svgFontSize,
              height: height, color: color ?? Get.theme.colorScheme.surface),
        ),
      ),
      color: Get.theme.colorScheme.primary.withValues(alpha: .8),
      iconSize: height ?? 35.0,
      itemBuilder: (context) => [
        PopupMenuItem(
          height: 30,
          child: Obx(
            () => SizedBox(
              height: 30,
              width: MediaQuery.sizeOf(context).width,
              child: FlutterSlider(
                values: [GeneralController.instance.fontSizeArabic.value],
                max: 50,
                min: 20,
                rtl: true,
                trackBar: FlutterSliderTrackBar(
                  inactiveTrackBarHeight: 5,
                  activeTrackBarHeight: 5,
                  inactiveTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Get.theme.colorScheme.surface,
                  ),
                  activeTrackBar: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Get.theme.colorScheme.primaryContainer),
                ),
                handlerAnimation: const FlutterSliderHandlerAnimation(
                    curve: Curves.elasticOut,
                    reverseCurve: null,
                    duration: Duration(milliseconds: 700),
                    scale: 1.4),
                onDragging: (handlerIndex, lowerValue, upperValue) async {
                  lowerValue = lowerValue;
                  upperValue = upperValue;
                  GeneralController.instance.fontSizeArabic.value = lowerValue;

                  box.write(FONT_SIZE, lowerValue);
                },
                handler: FlutterSliderHandler(
                  decoration: const BoxDecoration(),
                  child: Material(
                    type: MaterialType.circle,
                    color: Colors.transparent,
                    elevation: 3,
                    child: SvgPicture.asset(SvgPath.svgZakhrafah),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
