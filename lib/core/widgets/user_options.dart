import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../presentation/controllers/general_controller.dart';
import '../services/services_locator.dart';
import 'beige_container.dart';

class UserOptions extends StatelessWidget {
  const UserOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final generalCtrl = sl<GeneralController>();
    return BeigeContainer(
      color: Theme.of(context).colorScheme.surface.withOpacity(.15),
      myWidget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            InkWell(
              child: Row(
                children: [
                  Icon(
                    Icons.share_outlined,
                    color: Theme.of(context).primaryColorLight,
                    size: 22,
                  ),
                  Container(
                    width: 2,
                    height: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  Text(
                    'share'.tr,
                    style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontFamily: 'kufi',
                        fontStyle: FontStyle.italic,
                        fontSize: 14),
                  ),
                ],
              ),
              onTap: () async {
                generalCtrl.share();
              },
            ),
            const Divider(),
            InkWell(
              child: Row(
                children: [
                  Icon(
                    Icons.email_outlined,
                    color: Theme.of(context).primaryColorLight,
                    size: 22,
                  ),
                  Container(
                    width: 2,
                    height: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  Text(
                    'email'.tr,
                    style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontFamily: 'kufi',
                        fontStyle: FontStyle.italic,
                        fontSize: 14),
                  ),
                ],
              ),
              onTap: () {
                generalCtrl.launchEmail();
              },
            ),
            const Divider(),
            InkWell(
              child: Row(
                children: [
                  Icon(
                    Icons.facebook_rounded,
                    color: Theme.of(context).primaryColorLight,
                    size: 22,
                  ),
                  Container(
                    width: 2,
                    height: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  Text(
                    'facebook'.tr,
                    style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontFamily: 'kufi',
                        fontStyle: FontStyle.italic,
                        fontSize: 14),
                  ),
                ],
              ),
              onTap: () {
                generalCtrl.launchUrl(
                    Uri.parse('https://www.facebook.com/alheekmahlib'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
