import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahawi/core/utils/constants/extensions/svg_extensions.dart';

import '/core/utils/constants/extensions.dart';
import '../../presentation/controllers/general_controller.dart';
import '../../presentation/screens/all_books/controller/audio/audio_controller.dart';
import '../services/services_locator.dart';
import '../utils/constants/svg_constants.dart';

orientation(BuildContext context, var n1, n2) {
  Orientation orientation = MediaQuery.orientationOf(context);
  return orientation == Orientation.portrait ? n1 : n2;
}

platformView(var p1, p2) {
  return (Platform.isIOS || Platform.isAndroid || Platform.isFuchsia) ? p1 : p2;
}

screenModalBottomSheet(BuildContext context, Widget child) {
  double hei = MediaQuery.sizeOf(context).height;
  double wid = MediaQuery.sizeOf(context).width;
  showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
          maxWidth: platformView(
              context.customOrientation(wid, wid * .7), wid / 1 / 2 * 1.5),
          maxHeight: context.customOrientation(
              hei * .9, platformView(hei, hei * 3 / 4))),
      elevation: 0.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return child;
      });
}

optionsModalBottomSheet(BuildContext context, Widget child, {double? height}) {
  double hei = MediaQuery.sizeOf(context).height;
  double wid = MediaQuery.sizeOf(context).width;
  showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
          maxWidth:
              platformView(context.customOrientation(wid, wid * .5), wid * .5),
          maxHeight: height ??
              context.customOrientation(hei * .5, platformView(hei, hei * .5))),
      elevation: 0.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return child;
      });
}

Widget greeting(BuildContext context) {
  return Text(
    '| ${sl<GeneralController>().greeting.value} |',
    style: TextStyle(
      fontSize: 14.0,
      fontFamily: 'kufi',
      color: Theme.of(context).colorScheme.primary,
    ),
    textAlign: TextAlign.center,
  );
}

Widget customDivider(BuildContext context, {double? height, double? width}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(8))),
  );
}

Widget delete(BuildContext context) {
  return Container(
    // height: 55,
    width: MediaQuery.sizeOf(context).width,
    decoration: const BoxDecoration(
        color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(4))),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    margin: const EdgeInsets.symmetric(vertical: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.close_outlined,
              color: Colors.white,
              size: 18,
            ),
            Text(
              'delete'.tr,
              style: const TextStyle(
                  color: Colors.white, fontSize: 14, fontFamily: 'kufi'),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.close_outlined,
              color: Colors.white,
              size: 18,
            ),
            Text(
              'delete'.tr,
              style: const TextStyle(
                  color: Colors.white, fontSize: 14, fontFamily: 'kufi'),
            )
          ],
        ),
      ],
    ),
  );
}

Widget vDivider(BuildContext context, {double? height, Color? color}) {
  return Container(
    height: height ?? 20,
    width: 2,
    margin: const EdgeInsets.symmetric(horizontal: 8.0),
    color: color ?? Theme.of(context).colorScheme.surface,
  );
}

Widget hDivider(BuildContext context, {double? width}) {
  return Container(
    height: 1,
    width: width ?? MediaQuery.sizeOf(context).width,
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    color: Theme.of(context).colorScheme.surface,
  );
}

Widget container(BuildContext context, Widget myWidget, bool show,
    {double? height, double? width, Color? color}) {
  return ClipRRect(
    child: Container(
      height: height,
      width: width!,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.secondary,
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          show == true
              ? Transform.translate(
                  offset: const Offset(0, -10),
                  child: Opacity(
                    opacity: .05,
                    child: context.customSvg(
                      SvgPath.svgSyntactic,
                      width: MediaQuery.sizeOf(context).width,
                    ),
                  ),
                )
              : Container(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 15,
              width: MediaQuery.sizeOf(context).width,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: myWidget,
          )
        ],
      ),
    ),
  );
}

Widget customClose(
  BuildContext context, {
  var close,
  Color? color,
  Color? color2,
}) {
  return GestureDetector(
    onTap: close ??
        () {
          AudioController.instance.state.audioWidgetPosition.value = -240.0;
        },
    child: Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.close_outlined,
            size: 32,
            color: color ??
                Theme.of(context).colorScheme.secondary.withValues(alpha: .5)),
        Icon(Icons.close_outlined,
            size: 16, color: color2 ?? Theme.of(context).colorScheme.secondary),
      ],
    ),
  );
}
