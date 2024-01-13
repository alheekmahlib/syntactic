import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/services/services_locator.dart';
import '../../../core/utils/constants/svg_picture.dart';
import '../../../core/widgets/widgets.dart';
import '../../controllers/splashScreen_controller.dart';
import 'widgets/alheekmah_and_loading.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    sl<SplashScreenController>().startTime();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: orientation(
              context,
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: syntactic_r(context, width: 100),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 10,
                        width: MediaQuery.sizeOf(context).width,
                        margin: const EdgeInsets.only(top: 8.0),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      const Gap(16),
                      RotatedBox(
                        quarterTurns: 15,
                        child: syntactic(
                          context,
                          height: 40,
                          width: 40,
                        ),
                      ),
                      const Gap(16),
                      Container(
                        height: 10,
                        width: MediaQuery.sizeOf(context).width,
                        margin: const EdgeInsets.only(top: 8.0),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ],
                  ),
                  const AlheekmahAndLoading()
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: syntactic_r(context, width: 100),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 10,
                        width: MediaQuery.sizeOf(context).width,
                        margin: const EdgeInsets.only(top: 8.0),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      const Gap(16),
                      RotatedBox(
                        quarterTurns: 15,
                        child: syntactic(
                          context,
                          height: 40,
                          width: 40,
                        ),
                      ),
                      const Gap(16),
                      Container(
                        height: 10,
                        width: MediaQuery.sizeOf(context).width,
                        margin: const EdgeInsets.only(top: 8.0),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ],
                  ),
                  const AlheekmahAndLoading()
                ],
              )),
        ),
      ),
    );
  }
}
