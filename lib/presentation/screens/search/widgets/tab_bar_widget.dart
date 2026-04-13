import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/helpers/app_text_styles.dart';
import '../controller/search_controller.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: Get.width,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: .12),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: TabBar(
        controller: SearchControllers.instance.state.tabController,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Theme.of(context).primaryColorDark,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: AppTextStyles.titleMedium(
          color: Theme.of(context).canvasColor,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        unselectedLabelStyle: AppTextStyles.titleMedium(
          color: Theme.of(context).primaryColorDark,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        indicator: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            color: Theme.of(context).primaryColorDark),
        tabs: [
          Tab(
            text: 'poetry'.tr,
          ),
          Tab(
            text: 'books'.tr,
          ),
          Tab(
            text: 'explanation'.tr,
          ),
        ],
      ),
    );
  }
}
