import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizontal_stepper_step/horizontal_stepper_step.dart';

import '/core/utils/constants/extensions.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lists.dart';
import '../../../../core/widgets/beige_container.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});
  final onboarding = sl<OnboardingController>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.sizeOf(context).height * .9,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FittedBox(
                    child: Obx(
                      () => HorizontalStepper(
                        totalStep: 5,
                        completedStep: onboarding.pageNumber.value,
                        selectedColor: Theme.of(context).colorScheme.surface,
                        backGroundColor: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(.2),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(
                        () => onboarding.pageNumber.value == 5
                            ? Align(
                                alignment: Alignment.topLeft,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0),
                                  onPressed: () {
                                    if (onboarding.pageNumber.value == 5) {
                                      Navigator.pop(context);
                                    } else {
                                      onboarding.controller.animateToPage(
                                          onboarding.controller.page!.toInt() +
                                              1,
                                          duration:
                                              const Duration(milliseconds: 400),
                                          curve: Curves.easeIn);
                                    }
                                  },
                                  child: Text('أبدأ',
                                      style: TextStyle(
                                          fontFamily: 'kufi',
                                          fontSize: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface)),
                                ),
                              )
                            : Align(
                                alignment: Alignment.topLeft,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0),
                                  onPressed: () {
                                    onboarding.controller.animateToPage(
                                        onboarding.controller.page!.toInt() + 1,
                                        duration:
                                            const Duration(milliseconds: 400),
                                        curve: Curves.easeIn);
                                  },
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                ),
                              ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, elevation: 0),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'تخطي',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(.4),
                            fontSize: 16.0,
                            fontFamily: 'kufi',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Flexible(
                child: Padding(
                  padding: orientation(
                      context,
                      const EdgeInsets.only(
                        top: 8.0,
                      ),
                      const EdgeInsets.only(
                        top: 60.0,
                      )),
                  child: PageView.builder(
                      controller: onboarding.controller,
                      itemCount: platformView(
                          context.customOrientation(
                              images.length, images.length),
                          images.length),
                      onPageChanged: (page) {
                        onboarding.pageNumber.value = page + 1;
                        onboarding.indicator(page);
                      },
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          child: Wrap(
                            children: [
                              Center(
                                child: BeigeContainer(
                                  myWidget: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      platformView(
                                          context.customOrientation(
                                              images[index], imagesL[index]),
                                          imagesD[index]),
                                    ),
                                  ),
                                  width: platformView(
                                      MediaQuery.sizeOf(context).width * .8,
                                      MediaQuery.sizeOf(context).width /
                                          1 /
                                          2 *
                                          .8),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 50,
                                        width: 10,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(4),
                                              bottomRight: Radius.circular(4),
                                            ))),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      flex: 9,
                                      child: Text(
                                        onboardingTitle[index],
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            fontSize: 18,
                                            height: 2,
                                            fontFamily: 'kufi'),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
