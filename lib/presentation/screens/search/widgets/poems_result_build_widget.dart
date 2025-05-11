import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahawi/presentation/screens/all_books/controller/extensions/books_ui.dart';

import '../../../../core/utils/constants/lottie.dart';
import '../../../../core/widgets/beige_container.dart';
import '../../../../core/widgets/widgets.dart';
import '../../all_books/controller/books_controller.dart';
import '../controller/search_controller.dart';
import '../data/models/search_result_model.dart';

class PoemsResultBuildWidget extends StatelessWidget {
  PoemsResultBuildWidget({super.key});

  final booksCtrl = AllBooksController.instance;
  // final searchCtrl = SearchControllers.instance;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchControllers>(builder: (searchCtrl) {
      return searchCtrl.state.searchResults.isEmpty
          ? searchLoading(height: 100.0)
          : ListView.builder(
              itemCount: searchCtrl.state.searchResults.length,
              itemBuilder: (context, index) {
                SearchResult result = searchCtrl.state.searchResults[index];
                return GestureDetector(
                  onTap: () => booksCtrl.moveToBookPage(
                    result.chapterIndex,
                    booksCtrl.state.booksList[result.bookNumber + 1].bookNumber,
                    type: booksCtrl
                        .state.booksList[result.bookNumber + 1].bookType,
                  ),
                  child: Container(
                    height: 95,
                    width: 380,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: BeigeContainer(
                            height: 125,
                            width: 380,
                            color: Theme.of(context)
                                .colorScheme
                                .surface
                                .withValues(alpha: .15),
                            myWidget: Row(
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
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.justify,
                                    textDirection: TextDirection.rtl,
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
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4))),
                            child: Text(
                              result.chapterTitle,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'kufi',
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.secondary,
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
    });
  }
}
