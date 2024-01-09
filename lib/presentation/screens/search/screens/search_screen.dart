import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:syntactic/presentation/controllers/books_controller.dart';
import 'package:syntactic/presentation/screens/books/poems_screen/screens/poems_read_view.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/utils/constants/svg_picture.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/search_controller.dart';
import '../data/models/search_result_model.dart';
import '../widgets/search_options.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchCtrl = sl<SearchControllers>();
    final bookCtrl = sl<BooksController>();
    bookCtrl.loadBook();
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0),
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
                      color:
                          Theme.of(context).colorScheme.surface.withOpacity(.5),
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
            Container(
              height: 80,
              width: orientation(context, MediaQuery.sizeOf(context).width * .9,
                  MediaQuery.sizeOf(context).width * .5),
              margin: const EdgeInsets.only(top: 32.0),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 8,
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            controller: searchCtrl.textSearchController,
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
                                child: search(context),
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
                            onSubmitted: (query) async {
                              await searchCtrl.addSearchItem(query);
                              searchCtrl.textSearchController.clear();
                            },
                            onChanged: (query) {
                              searchCtrl.search(query);
                            },
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                          ),
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          child: Container(
                            height: 50,
                            width: 50,
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorDark,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            child: setting_lines(context),
                          ),
                          onTap: () {
                            Get.bottomSheet(const SearchOptions(),
                                isScrollControlled: false);
                          },
                        ),
                      ),
                    ],
                  ),
                  hDivider(context,
                      width: MediaQuery.sizeOf(context).width * .8),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                return searchCtrl.searchResults.isEmpty
                    ? searchCtrl.searchHistory.isEmpty
                        ? searchLoading(height: 100.0)
                        : Column(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'lastSearch'.tr,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'kufi',
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: ListView.builder(
                                  itemCount: searchCtrl.searchHistory.length,
                                  itemBuilder: (context, index) {
                                    final item =
                                        searchCtrl.searchHistory[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 16.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          searchCtrl.textSearchController.text =
                                              item.query;
                                          searchCtrl.search(item.query);
                                        },
                                        child: beigeContainer(
                                          context,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface
                                              .withOpacity(.15),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    search(context),
                                                    customDivider(context,
                                                        height: 25, width: 2),
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
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                            .withOpacity(.8),
                                                      ),
                                                    ),
                                                    Text(
                                                      item.timestamp,
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        fontFamily: 'kufi',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                            .withOpacity(.5),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: IconButton(
                                                    onPressed: () => sl<
                                                            SearchControllers>()
                                                        .removeSearchItem(
                                                            searchCtrl
                                                                    .searchHistory[
                                                                index]),
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
                          )
                    : ListView.builder(
                        itemCount: searchCtrl.searchResults.length,
                        itemBuilder: (context, index) {
                          bookCtrl.loadBook();
                          SearchResult result = searchCtrl.searchResults[index];
                          return GestureDetector(
                            onTap: () => Get.to(
                                PoemsReadView(
                                    chapterNumber: result.chapterIndex),
                                transition: Transition.downToUp),
                            child: Container(
                              height: 95,
                              width: 380,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 16.0),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: beigeContainer(
                                      context,
                                      height: 125,
                                      width: 380,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface
                                          .withOpacity(.15),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              result.bookName,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontFamily: 'kufi',
                                                  fontWeight: FontWeight.w500,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  height: 1.5),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          vDivider(context, height: 50),
                                          Expanded(
                                            flex: 8,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                result.firstPoem,
                                                style: TextStyle(
                                                    fontSize: 22.0,
                                                    fontFamily: 'naskh',
                                                    fontWeight: FontWeight.w500,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    height: 1.5),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.justify,
                                                textDirection:
                                                    TextDirection.rtl,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Transform.translate(
                                    offset: const Offset(-50, 45),
                                    child: Container(
                                      height: 32,
                                      width: 220,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4))),
                                      child: Text(
                                        result.chapterTitle,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontFamily: 'kufi',
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
