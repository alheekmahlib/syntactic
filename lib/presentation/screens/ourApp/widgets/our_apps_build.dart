import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/widgets/widgets.dart';
import '../controller/our_apps_controller.dart';
import '../data/models/our_app_model.dart';

class OurAppsBuild extends StatelessWidget {
  OurAppsBuild({super.key});

  final ourApps = OurAppsController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ConnectivityService.instance.noConnection.value
          ? ConnectivityService.instance.noInternetWidget
          : FutureBuilder<List<OurAppInfo>>(
              future: ourApps.fetchApps(),
              builder: (context, snapshot) {
                if (ourApps.errorMessage.value.isNotEmpty) {
                  return Text(
                    ourApps.errorMessage.value.tr,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 20,
                        fontFamily: 'kufi',
                        fontWeight: FontWeight.bold),
                  );
                }
                if (snapshot.hasData) {
                  List<OurAppInfo>? apps = snapshot.data;
                  return Padding(
                    padding: context.customOrientation(
                        const EdgeInsets.only(top: 130.0),
                        const EdgeInsets.only(top: 46.0)),
                    child: Column(
                      children: [
                        Text(
                          'ourApps'.tr,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontSize: 20,
                              fontFamily: 'kufi',
                              fontWeight: FontWeight.bold),
                        ),
                        hDivider(context),
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: false,
                            padding: EdgeInsets.zero,
                            itemCount: apps!.length,
                            separatorBuilder: (context, i) => i == 2
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32.0),
                                    child: hDivider(
                                      context,
                                    ),
                                  ),
                            itemBuilder: (context, index) {
                              // if (index >= 2) {
                              //   index++;
                              // }
                              return index == 2
                                  ? const SizedBox.shrink()
                                  : InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8))),
                                        padding: const EdgeInsets.all(8.0),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SvgPicture.network(
                                              apps[index].appLogo,
                                              height: 45,
                                              width: 45,
                                            ),
                                            vDivider(context, height: 40.0),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    apps[index].appTitle,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                        fontSize: 13,
                                                        fontFamily: 'kufi',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 8.0.h,
                                                  ),
                                                  Text(
                                                    apps[index].body,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .surface
                                                            .withValues(
                                                                alpha: .7),
                                                        fontSize: 11,
                                                        fontFamily: 'kufi',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // InfoPopupWidget(
                                            //   contentTitle:
                                            //       apps[index].aboutApp3.tr,
                                            //   arrowTheme: InfoPopupArrowTheme(
                                            //     color: Theme.of(context)
                                            //         .colorScheme
                                            //         .surface,
                                            //     arrowDirection:
                                            //         ArrowDirection.down,
                                            //   ),
                                            //   contentTheme:
                                            //       InfoPopupContentTheme(
                                            //     infoContainerBackgroundColor:
                                            //         Theme.of(context)
                                            //             .colorScheme
                                            //             .primaryContainer,
                                            //     infoTextStyle: TextStyle(
                                            //         color: Theme.of(context)
                                            //             .colorScheme
                                            //             .surface,
                                            //         fontSize: 12,
                                            //         fontFamily: 'kufi'),
                                            //     contentPadding:
                                            //         const EdgeInsets.all(16.0),
                                            //     contentBorderRadius:
                                            //         const BorderRadius.all(
                                            //             Radius.circular(4)),
                                            //     infoTextAlign:
                                            //         TextAlign.justify,
                                            //   ),
                                            //   dismissTriggerBehavior:
                                            //       PopupDismissTriggerBehavior
                                            //           .onTapArea,
                                            //   areaBackgroundColor:
                                            //       Colors.transparent,
                                            //   indicatorOffset: Offset.zero,
                                            //   contentOffset: Offset.zero,
                                            //   child: Icon(
                                            //     Icons.info_outline_rounded,
                                            //     color: Theme.of(context)
                                            //         .colorScheme
                                            //         .surface,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        ourApps.launchURL(
                                            context, index, apps[index]);
                                      },
                                    );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return loading(width: 200.0, height: 200.0);
              },
            ),
    );
  }
}
