import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../presentation/controllers/general_controller.dart';
import '../../utils/constants/svg_constants.dart';
import 'controller/local_notifications_controller.dart';
import 'widgets/notification_icon_widget.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});
  final notiCtrl = LocalNotificationsController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * .8,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.close_outlined,
                          size: 32,
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withValues(alpha: .5)),
                      Icon(Icons.close_outlined,
                          size: 16,
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ],
                  ),
                ),
                const Gap(8),
                context.vDivider(height: 20),
                const Gap(8),
                Text(
                  'notification'.tr,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontFamily: 'kufi',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const Gap(32),
            Flexible(
              child: GetBuilder<LocalNotificationsController>(
                builder: (notiCtrl) => notiCtrl.postsList.isEmpty
                    ? Center(
                        child: Column(
                          children: [
                            const Gap(64),
                            customSvgWithColor(SvgPath.svgNotifications,
                                color: context.theme.colorScheme.surface,
                                width: 80),
                            const Gap(32),
                            Text(
                              'noNotifications'.tr,
                              style: TextStyle(
                                color: context.theme.colorScheme.inversePrimary,
                                fontFamily: 'kufi',
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: NotificationIconWidget(
                              isCurve: false,
                              iconHeight: 60.0,
                              padding: 8.0,
                            ),
                          ),
                          const Gap(16),
                          Flexible(
                            child: ListView.builder(
                              itemCount: notiCtrl.postsList.length,
                              itemBuilder: (context, index) {
                                var reversedList =
                                    notiCtrl.postsList.reversed.toList();
                                var noti = reversedList[index];
                                return noti.appName == 'nahawi'
                                    ? ExpansionTileCard(
                                        elevation: 0.0,
                                        initialElevation: 0.0,
                                        baseColor: Theme.of(context)
                                            .canvasColor
                                            .withValues(alpha: .2),
                                        expandedColor: Theme.of(context)
                                            .canvasColor
                                            .withValues(alpha: .2),
                                        onExpansionChanged: (_) => notiCtrl
                                            .markNotificationAsRead(noti.id),
                                        title: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 8.0),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          decoration: BoxDecoration(
                                            color: noti.opened
                                                ? Theme.of(context)
                                                    .canvasColor
                                                    .withValues(alpha: .1)
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .surface
                                                    .withValues(alpha: .15),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8)),
                                            border: Border.all(
                                              width: 1,
                                              color: noti.opened
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .surface
                                                  : Theme.of(context)
                                                      .primaryColorDark,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                noti.title,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  fontFamily: 'kufi',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              customSvgWithColor(
                                                SvgPath.svgNotifications,
                                                height: 25,
                                                color: noti.opened
                                                    ? Theme.of(context)
                                                        .primaryColorDark
                                                        .withValues(alpha: .7)
                                                    : Theme.of(context)
                                                        .primaryColorDark,
                                              ),
                                            ],
                                          ),
                                        ),
                                        children: <Widget>[
                                          Text(
                                            noti.title,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontFamily: 'kufi',
                                              fontWeight: FontWeight.bold,
                                              fontSize: GeneralController
                                                  .instance
                                                  .fontSizeArabic
                                                  .value,
                                            ),
                                          ),
                                          context.hDivider(width: Get.width),
                                          const Gap(16),
                                          Text(
                                            noti.body,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontFamily: 'kufi',
                                              fontWeight: FontWeight.bold,
                                              fontSize: GeneralController
                                                      .instance
                                                      .fontSizeArabic
                                                      .value -
                                                  2,
                                            ),
                                          ),
                                          const Gap(32),
                                          noti.isLottie &&
                                                  noti.lottie.isNotEmpty
                                              ? Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 8.0),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .canvasColor
                                                        .withValues(alpha: .15),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(8)),
                                                    border: Border.all(
                                                      width: 1,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                    ),
                                                  ),
                                                  child: Lottie.network(
                                                    noti.lottie,
                                                    width: Get.width * .5,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        const CircularProgressIndicator
                                                            .adaptive(),
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                          const Gap(32),
                                          noti.isImage && noti.image.isNotEmpty
                                              ? Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 8.0),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .canvasColor
                                                        .withValues(alpha: .15),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(8)),
                                                    border: Border.all(
                                                      width: 1,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                    ),
                                                  ),
                                                  child: Image.network(
                                                    noti.image,
                                                    width: Get.width * .5,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        const CircularProgressIndicator
                                                            .adaptive(),
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                          const Gap(8),
                                          context.hDivider(width: Get.width),
                                          const Gap(16),
                                        ],
                                      )
                                    : const SizedBox.shrink();
                              },
                            ),
                          )
                        ],
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
