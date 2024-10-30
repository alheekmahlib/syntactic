import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:get/get.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '/core/utils/constants/extensions.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '/core/utils/constants/svg_constants.dart';
import '/core/widgets/settings_list.dart';
import '/presentation/controllers/onboarding_controller.dart';
import '../../../core/services/services_locator.dart';
import '../../../core/utils/constants/lists.dart';
import '../../../core/widgets/widgets.dart';
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
    double height = MediaQuery.sizeOf(context).height;
    settings.loadLang();
    sl<OnboardingController>().startOnboarding();
    generalCtrl.updateGreeting();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ThemeSwitchingArea(
        child: Scaffold(
          extendBody: false,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          body: SafeArea(
            child: SliderDrawer(
              key: generalCtrl.key,
              splashColor: Theme.of(context).colorScheme.primaryContainer,
              slideDirection: context.customOrientation(
                  SlideDirection.TOP_TO_BOTTOM, SlideDirection.RIGHT_TO_LEFT),
              sliderOpenSize: platformView(
                  orientation(
                      context, height / 1 / 2 * 1.1, height / 1 / 2 * 1.5),
                  height / 1 / 2 * 1.1),
              isCupertino: true,
              isDraggable: true,
              appBar: SliderAppBar(
                appBarColor: Theme.of(context).colorScheme.primaryContainer,
                appBarPadding: orientation(
                    context,
                    const EdgeInsets.symmetric(horizontal: 16.0),
                    const EdgeInsets.symmetric(horizontal: 40.0)),
                drawerIconSize: 1.0,
                drawerIconColor: Colors.transparent,
                drawerIcon: const SizedBox.shrink(),
                appBarHeight: 40.h,
                isTitleCenter: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.menu,
                        size: 24.h,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      onPressed: () => generalCtrl.key.currentState?.toggle(),
                    ),
                    customSvg(SvgPath.svgSyntactic, height: 20),
                  ],
                ),
              ),
              slider: const SettingsList(),
              child: PageView(
                controller: generalCtrl.controller,
                onPageChanged: (index) {
                  generalCtrl.selected.value = index;
                  print('selected ${generalCtrl.selected.value}');
                },
                children: [
                  HomeScreen(),
                  BooksBuild(showAllBooks: true),
                  BookmarksScreen(),
                ],
              ),
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.startDocked,
        ),
      ),
    );
  }
}
