import 'dart:developer';

import 'package:floating_menu_expendable/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/constants/svg_constants.dart';
import '/presentation/controllers/onboarding_controller.dart';
import '../../../core/services/services_locator.dart';
import '../../../core/utils/constants/lists.dart';
import '../../../core/widgets/settings_list.dart';
import '../../controllers/general_controller.dart';
import '../../controllers/settings_controller.dart';
import '../all_books/widgets/books_build.dart';
import '../bookmark/screens/bookmarks_screen.dart';
import '../home/screen/home_screen.dart';
import '../search/screens/search_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final generalCtrl = GeneralController.instance;
  final settings = SettingsController.instance;

  @override
  Widget build(BuildContext context) {
    settings.loadLang();
    sl<OnboardingController>().startOnboarding();
    generalCtrl.updateGreeting();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBody: false,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: SafeArea(
          child: Stack(
            children: [
              // const SettingsList(),
              Padding(
                padding: const EdgeInsets.only(top: 48.0),
                child: PageView(
                  controller: generalCtrl.controller,
                  onPageChanged: (index) {
                    generalCtrl.selected.value = index;
                    log('selected ${generalCtrl.selected.value}');
                  },
                  children: [
                    HomeScreen(),
                    BooksBuild(showAllBooks: true),
                    BookmarksScreen(),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: customSvg(SvgPath.svgSyntactic, height: 20),
                ),
              ),
              FloatingMenuWidget(
                controller: FloatingMenuExpendableController(),
              )
            ],
          ),
        ),
        bottomNavigationBar: Directionality(
          textDirection: TextDirection.rtl,
          child: Obx(
            () => StylishBottomBar(
              items: List.generate(
                navBarList.length,
                (i) => BottomBarItem(
                  icon: customSvgWithColor(navBarList[i]['svgPath'],
                      width: 20.h,
                      color: Theme.of(context).colorScheme.primary),
                  selectedIcon: customSvgWithColor(navBarList[i]['svgPath'],
                      width: 20.h,
                      color: Theme.of(context).colorScheme.secondary),
                  // selectedColor: Colors.teal,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  title: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${navBarList[i]['title']}'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'kufi',
                        color: generalCtrl.selected.value == i
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
              hasNotch: true,
              fabLocation: StylishBarFabLocation.end,
              currentIndex: generalCtrl.selected.value,
              onTap: (index) {
                generalCtrl.controller.jumpToPage(index);
                generalCtrl.selected.value = index;
              },
              option: AnimatedBarOptions(
                  barAnimation: BarAnimation.fade,
                  iconStyle: IconStyle.Default,
                  inkEffect: false,
                  inkColor: context.theme.primaryColor),
              backgroundColor: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              elevation: 80,
            ),
          ),
        ),
        floatingActionButton: SizedBox(
          height: 50.0,
          width: 50.0,
          child: FloatingActionButton(
            onPressed: () {
              Get.bottomSheet(
                SearchScreen(),
                isScrollControlled: true,
              );
            },
            backgroundColor: Theme.of(context).colorScheme.onSurface,
            child: customSvgWithColor(SvgPath.svgSearch,
                width: 22.h, color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      ),
    );
  }
}

class FloatingMenuWidget extends StatelessWidget {
  const FloatingMenuWidget({
    super.key,
    required this.controller,
  });

  final FloatingMenuExpendableController controller;

  @override
  Widget build(BuildContext context) {
    return FloatingMenuExpendable(
      controller: controller,
      panelWidth: 460,
      panelHeight: 360,
      handleWidth: 40,
      handleHeight: 40,
      expandPanelFromHandle: true,
      initialPosition: const Offset(12, 12),
      openMode: FloatingMenuExpendableOpenMode.vertical,
      style: FloatingMenuExpendableStyle(
        // Background barrier
        showBarrierWhenOpen: true,
        barrierDismissible: true,
        barrierColor:
            context.theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        barrierBlurSigmaX: 10,
        barrierBlurSigmaY: 10,
        panelDecoration: BoxDecoration(
          color: context.theme.colorScheme.surface.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        // Panel
        panelBorderRadius: BorderRadius.circular(8),
      ),
      handleChild: Icon(
        Icons.menu,
        size: 24,
        color: context.theme.canvasColor,
      ),
      panelChild: const SettingsList(),
    );
  }
}
