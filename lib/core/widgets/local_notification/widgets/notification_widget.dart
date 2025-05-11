import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../controller/local_notifications_controller.dart';

class NotificationWidget extends StatelessWidget {
  final int postId;
  NotificationWidget({super.key, required this.postId});

  final notiCtrl = LocalNotificationsController.instance;

  @override
  Widget build(BuildContext context) {
    final post = notiCtrl.postsList[postId - 1];
    return Container(
      height: Get.height * .9,
      width: Get.width,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                        .secondary
                        .withValues(alpha: .5)),
                Icon(Icons.close_outlined,
                    size: 16, color: Theme.of(context).colorScheme.secondary),
              ],
            ),
          ),
          Text(
            post.title,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(16.0),
          Text(
            post.body,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
