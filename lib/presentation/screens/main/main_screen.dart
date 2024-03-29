import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:get/get.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../../../core/services/services_locator.dart';
import '../../../core/utils/constants/svg_picture.dart';
import '../../../core/widgets/widgets.dart';
import '../../controllers/general_controller.dart';
import '../../controllers/settings_controller.dart';
import '../bookmark/screens/bookmarks_screen.dart';
import '../books/screen/books_build.dart';
import '../home/screen/home_screen.dart';
import '../search/screens/search_screen.dart';
import '/core/utils/constants/extensions.dart';
import '/core/widgets/settings_list.dart';
import '/presentation/controllers/onboarding_controller.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    final general = sl<GeneralController>();
    final settings = sl<SettingsController>();
    settings.loadLang();
    sl<OnboardingController>().startOnboarding();
    general.updateGreeting();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ThemeSwitchingArea(
        child: Scaffold(
          extendBody: false,
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: SliderDrawer(
              key: sl<GeneralController>().key,
              splashColor: Theme.of(context).colorScheme.background,
              slideDirection: context.customOrientation(
                  SlideDirection.TOP_TO_BOTTOM, SlideDirection.RIGHT_TO_LEFT),
              sliderOpenSize: platformView(
                  orientation(
                      context, height / 1 / 2 * 1.1, height / 1 / 2 * 1.5),
                  height / 1 / 2 * 1.1),
              isCupertino: true,
              isDraggable: true,
              appBar: SliderAppBar(
                appBarColor: Theme.of(context).colorScheme.background,
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
                      onPressed: () =>
                          sl<GeneralController>().key.currentState?.toggle(),
                    ),
                    syntactic(context, height: 20),
                  ],
                ),
              ),
              slider: const SettingsList(),
              child: PageView(
                controller: sl<GeneralController>().controller,
                onPageChanged: (index) {
                  sl<GeneralController>().selected.value = index;
                  print('selected ${sl<GeneralController>().selected.value}');
                },
                children: const [
                  HomeScreen(),
                  BooksBuild(),
                  BookmarksScreen(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Directionality(
            textDirection: TextDirection.rtl,
            child: Obx(
              () => StylishBottomBar(
                items: [
                  BottomBarItem(
                    icon: home(context),
                    selectedIcon: home(context),
                    // selectedColor: Colors.teal,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    title: Text(
                      'home'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'kufi',
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  BottomBarItem(
                    icon: books(context),
                    selectedIcon: books(context),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    title: Text(
                      'books'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'kufi',
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  BottomBarItem(
                      icon: bookmark(context),
                      selectedIcon: bookmark(context),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      title: Text(
                        'bookmark'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'kufi',
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )),
                ],
                hasNotch: true,
                fabLocation: StylishBarFabLocation.end,
                currentIndex: sl<GeneralController>().selected.value,
                onTap: (index) {
                  sl<GeneralController>().controller.jumpToPage(index);
                  sl<GeneralController>().selected.value = index;
                },
                option: AnimatedBarOptions(
                  barAnimation: BarAnimation.liquid,
                  iconStyle: IconStyle.animated,
                ),
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
                screenModalBottomSheet(
                  context,
                  const SearchScreen(),
                );
              },
              backgroundColor: Theme.of(context).colorScheme.onSurface,
              child: search(context,
                  color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.startDocked,
        ),
      ),
    );
  }
}
