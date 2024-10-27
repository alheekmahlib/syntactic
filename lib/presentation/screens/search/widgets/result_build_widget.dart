import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nahawi/core/utils/constants/extensions/extensions.dart';
import 'package:nahawi/core/utils/constants/extensions/highlight_extension.dart';
import 'package:nahawi/presentation/screens/all_books/controller/extensions/books_getters.dart';
import 'package:nahawi/presentation/screens/all_books/controller/extensions/books_ui.dart';

import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/widgets/beige_container.dart';
import '../../all_books/controller/books_controller.dart';
import '../../all_books/data/models/page_model.dart';
import '../controller/search_controller.dart';

class ResultBuild extends StatelessWidget {
  final String bookType;
  ResultBuild({super.key, required this.bookType});

  final booksCtrl = AllBooksController.instance;
  // final searchCtrl = SearchControllers.instance;

  @override
  Widget build(BuildContext context) {
    // searchCtrl.state.bookType = bookType;
    return 'explanation' == bookType && !booksCtrl.downloadedBooks.value
        ? Column(
            children: [
              const Gap(64),
              Text(
                'noBooksDownloaded'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontFamily: 'kufi',
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
              const Gap(64),
            ],
          )
        : GetBuilder<SearchControllers>(builder: (searchCtrl) {
            return searchCtrl.state.searchResults.isEmpty
                ? searchLoading(height: 100.0)
                : PagedListView<int, PageContent>(
                    pagingController: searchCtrl.state.pagingController,
                    builderDelegate: PagedChildBuilderDelegate<PageContent>(
                      itemBuilder: (context, r, index) {
                        final result =
                            searchCtrl.state.pagingController.itemList![index];
                        return GestureDetector(
                          onTap: () => booksCtrl.moveToBookPage(
                            result.pageNumber - 1,
                            result.bookNumber,
                            type: booksCtrl.state
                                .booksList[result.bookNumber - 1].bookType,
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 6.0),
                            child: BeigeContainer(
                              width: 380,
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(.15),
                              myWidget: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: RichText(
                                      text: TextSpan(
                                        children: result.content
                                            .processTextWithHighlight(searchCtrl
                                                .state.searchController.text),
                                        style: TextStyle(
                                            fontSize: 22.0,
                                            fontFamily: 'naskh',
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            height: 1.5),
                                      ),
                                      textAlign: TextAlign.justify,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                  Container(
                                    height: 32,
                                    width: Get.width,
                                    alignment: Alignment.center,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            result.bookTitle,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontFamily: 'kufi',
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        const Gap(16),
                                        context.vDivider(
                                            height: 20,
                                            color: context.theme.canvasColor),
                                        const Gap(16),
                                        Expanded(
                                          flex: 6,
                                          child: Text(
                                            booksCtrl
                                                .getChaptersByPage(
                                                    result.bookNumber,
                                                    result.pageNumber)
                                                .chapterName,
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
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
          });
  }
}
