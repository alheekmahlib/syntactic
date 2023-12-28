import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/services/services_locator.dart';
import '../../../core/utils/constants/svg_picture.dart';
import '../../../core/widgets/widgets.dart';
import '/presentation/controllers/ourApps_controller.dart';
import '/presentation/screens/ourApp/widgets/our_apps_build.dart';

class OurApps extends StatelessWidget {
  const OurApps({super.key});

  @override
  Widget build(BuildContext context) {
    sl<OurAppsController>().fetchApps();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: orientation(
            context,
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: container(
                    context,
                    const OurAppsBuild(),
                    false,
                    height: orientation(context, 450.0.h, 300.0.h),
                    width: MediaQuery.sizeOf(context).width,
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: Transform.translate(
                        offset: orientation(
                            context, Offset(0, -200.h), Offset(0, -130.h)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            syntactic_logo(
                              context,
                              width: 80.0.w,
                            ),
                            const Gap(16),
                            beigeContainer(
                                context,
                                whiteContainer(
                                  context,
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'فعليكم بسُنَّتي وسُنَّةِ الخُلَفاءِ الرَّاشِدينَ المَهْدِيِّينَ',
                                      style: TextStyle(
                                          fontFamily: 'kufi',
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                width: 300.0),
                          ],
                        ))),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: orientation(
                        context,
                        const EdgeInsets.symmetric(vertical: 64.0).r,
                        const EdgeInsets.symmetric(vertical: 32.0).r),
                    child: alheekmah_logo(context,
                        width: 80.w,
                        color: Theme.of(context).colorScheme.surface),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 48.0, right: 16.0).r,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: arrow_back(
                          context,
                          width: 26,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      )),
                ),
              ],
            ),
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 48.0, right: 56.0),
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: arrow_back(
                                    context,
                                    width: 26,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                )),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              syntactic_logo(
                                context,
                                width: 80.0,
                              ),
                              const Gap(16),
                              beigeContainer(
                                  context,
                                  whiteContainer(
                                    context,
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'فعليكم بسُنَّتي وسُنَّةِ الخُلَفاءِ الرَّاشِدينَ المَهْدِيِّينَ',
                                        style: TextStyle(
                                            fontFamily: 'kufi',
                                            color: Color(0xff3C2A21),
                                            fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  width: 300.0),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: whiteContainer(
                        context,
                        const OurAppsBuild(),
                        height: 300.0,
                        width: MediaQuery.sizeOf(context).width,
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: alheekmah_logo(
                      context,
                      width: 80,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
