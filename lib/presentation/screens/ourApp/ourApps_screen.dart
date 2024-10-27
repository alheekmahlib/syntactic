import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:nahawi/core/utils/constants/extensions/svg_extensions.dart';

import '/core/utils/constants/extensions.dart';
import '/presentation/controllers/ourApps_controller.dart';
import '/presentation/screens/ourApp/widgets/our_apps_build.dart';
import '../../../core/services/services_locator.dart';
import '../../../core/utils/constants/svg_constants.dart';
import '../../../core/widgets/beige_container.dart';
import '../../../core/widgets/white_container.dart';
import '../../../core/widgets/widgets.dart';
import '../../controllers/general_controller.dart';

class OurApps extends StatelessWidget {
  const OurApps({super.key});

  @override
  Widget build(BuildContext context) {
    sl<OurAppsController>().fetchApps();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        centerTitle: true,
        title: customSvg(SvgPath.svgSyntactic, height: 20),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: sl<GeneralController>().checkWidgetRtlLayout(
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Image.asset(
                    'assets/icons/arrow_back.png',
                    color: Theme.of(context).colorScheme.primary,
                  )),
            )),
        leadingWidth: 56,
      ),
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
                    height: context.customOrientation(450.0.h, 300.0.h),
                    width: MediaQuery.sizeOf(context).width,
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: Transform.translate(
                        offset: orientation(
                            context, Offset(0, -250.h), Offset(0, -130.h)),
                        child: customSvg(
                          SvgPath.svgSyntactic,
                          width: 80.0.w,
                        ))),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: orientation(
                        context,
                        const EdgeInsets.symmetric(vertical: 40.0).r,
                        const EdgeInsets.symmetric(vertical: 32.0).r),
                    child: customSvgWithColor(SvgPath.svgAlheekmahLogo,
                        width: 80.w,
                        color: Theme.of(context).colorScheme.surface),
                  ),
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
                                  child: customSvgWithColor(
                                      SvgPath.svgArrowBack,
                                      width: 26,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface),
                                )),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              customSvg(
                                SvgPath.svgSyntactic,
                                width: 80.0,
                              ),
                              const Gap(16),
                              BeigeContainer(
                                  myWidget: WhiteContainer(
                                    myWidget: const Padding(
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
                      child: WhiteContainer(
                        myWidget: const OurAppsBuild(),
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
                    child: customSvgWithColor(
                      SvgPath.svgAlheekmahLogo,
                      width: 80,
                      color: const Color(0xff3C2A21),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
