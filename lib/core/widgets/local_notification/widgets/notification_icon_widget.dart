import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../utils/constants/svg_constants.dart';
import '../controller/local_notifications_controller.dart';

class NotificationIconWidget extends StatelessWidget {
  final bool isCurve;
  final double iconHeight;
  final double? padding;
  NotificationIconWidget(
      {super.key,
      required this.isCurve,
      required this.iconHeight,
      required this.padding});

  final notiCtrl = LocalNotificationsController.instance;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        isCurve
            ? Transform.translate(
                offset: const Offset(0, -2),
                child: RotatedBox(
                  quarterTurns: 1,
                  child: customSvgWithColor(SvgPath.svgButtonCurve,
                      height: 45.0,
                      width: 45.0,
                      color: Get.theme.colorScheme.surface),
                ),
              )
            : const SizedBox.shrink(),
        Container(
          padding: EdgeInsets.all(padding ?? 0),
          margin: const EdgeInsets.only(bottom: 5.0),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(
                  width: 1,
                  color: isCurve
                      ? Theme.of(context).canvasColor
                      : context.theme.colorScheme.surface)),
          child: Obx(() {
            int unreadCount = notiCtrl.postsList
                .where((n) => n.appName == 'nahawi' && !n.opened)
                .length;

            return badges.Badge(
              showBadge: unreadCount > 0,
              position: badges.BadgePosition.bottomEnd(bottom: -22, end: -20),
              badgeStyle: badges.BadgeStyle(
                shape: badges.BadgeShape.square,
                badgeColor: Theme.of(context).colorScheme.primaryContainer,
                borderSide: BorderSide(
                  width: 1,
                  color: Theme.of(context).colorScheme.surface,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                borderRadius: BorderRadius.circular(4),
                elevation: 0,
              ),
              badgeContent: Text(
                unreadCount.toString().convertNumbers(),
                style: TextStyle(
                    fontFamily: 'naskh',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
              child: customSvgWithColor(SvgPath.svgNotifications,
                  color: isCurve
                      ? Theme.of(context).canvasColor
                      : context.theme.colorScheme.surface,
                  height: iconHeight),
            );
          }),
        ),
      ],
    );
  }
}
