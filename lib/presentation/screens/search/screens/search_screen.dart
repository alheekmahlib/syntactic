import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '/presentation/screens/all_books/controller/books_controller.dart';
import '/presentation/screens/search/controller/extensions/search_ui.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../controller/search_controller.dart';
import '../widgets/last_search_widget.dart';
import '../widgets/poems_result_build_widget.dart';
import '../widgets/result_build_widget.dart';
import '../widgets/tab_bar_widget.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final booksCtrl = AllBooksController.instance;
  final searchCtrl = SearchControllers.instance;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: Get.height * .94,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customClose(context, close: () {
                        searchCtrl.clearList();
                        Get.back();
                      },
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(.5),
                          color2: Theme.of(context).colorScheme.surface),
                      Text(
                        'search'.tr,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'kufi',
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width:
                      context.customOrientation(Get.width * .9, Get.width * .5),
                  child: Column(
                    children: [
                      const Gap(16),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: searchCtrl.state.searchController,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'kufi',
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.7),
                          ),
                          decoration: InputDecoration(
                            hintText: 'searchHintText'.tr,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorDark,
                                  width: 1),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorDark,
                                  width: 1),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            hintStyle: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'kufi',
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.3),
                            ),
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(.12),
                            prefixIcon: Container(
                              height: 20,
                              padding: const EdgeInsets.all(10.0),
                              child: customSvgWithColor(SvgPath.svgSearch,
                                  width: 22.h,
                                  color: Theme.of(context).colorScheme.surface),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                searchCtrl.clearList();
                              },
                            ),
                            labelText: 'searchHintText'.tr,
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'kufi',
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.5),
                            ),
                          ),
                          onSubmitted: (query) =>
                              searchCtrl.addSearchItem(query),
                          onChanged: (query) {
                            searchCtrl.searchBooks(query, false);
                            searchCtrl.searchPoems(query);
                          },
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        ),
                      ),
                      context.hDivider(width: Get.width * .8),
                      TabBarWidget(),
                    ],
                  ),
                ),
                const Gap(16),
                LastSearchWidget(),
                Flexible(
                  child: Container(
                    height: Get.height,
                    width: Get.width,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        )),
                    child: Column(
                      children: [
                        Flexible(
                          child: TabBarView(
                            controller: searchCtrl.state.tabController,
                            children: <Widget>[
                              PoemsResultBuildWidget(),
                              ResultBuild(bookType: 'book'),
                              ResultBuild(bookType: 'explanation'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
