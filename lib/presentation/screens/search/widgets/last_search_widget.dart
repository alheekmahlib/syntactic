import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:nahawi/core/utils/constants/extensions/extensions.dart';
import 'package:nahawi/core/utils/constants/extensions/svg_extensions.dart';
import 'package:nahawi/presentation/screens/search/controller/extensions/search_ui.dart';

import '../../../../core/utils/constants/svg_constants.dart';
import '../../../../core/widgets/beige_container.dart';
import '../controller/search_controller.dart';

class LastSearchWidget extends StatelessWidget {
  LastSearchWidget({super.key});

  final searchCtrl = SearchControllers.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() => searchCtrl.state.searchHistory.isNotEmpty &&
            searchCtrl.state.searchResults.isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const Gap(16),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'lastSearch'.tr,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'kufi',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    itemCount: searchCtrl.state.searchHistory.length,
                    itemBuilder: (context, index) {
                      final item = searchCtrl.state.searchHistory[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            searchCtrl.state.searchController.text = item.query;
                            searchCtrl.searchBooks(item.query, false);
                            searchCtrl.searchPoems(item.query);
                          },
                          child: BeigeContainer(
                            color: Theme.of(context)
                                .colorScheme
                                .surface
                                .withValues(alpha: .15),
                            myWidget: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      customSvgWithColor(SvgPath.svgSearch,
                                          width: 22.h,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface),
                                      context.vDivider(height: 25),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.query,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontFamily: 'kufi',
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: .8),
                                        ),
                                      ),
                                      Text(
                                        item.timestamp,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontFamily: 'kufi',
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: .5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                      onPressed: () =>
                                          searchCtrl.removeSearchItem(searchCtrl
                                              .state.searchHistory[index]),
                                      icon: Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                      )),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink());
  }
}
