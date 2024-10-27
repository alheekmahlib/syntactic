import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:nahawi/core/utils/constants/extensions/svg_extensions.dart';

import '../../../../core/utils/constants/svg_constants.dart';
import '../../../../core/widgets/beige_container.dart';
import '../controller/books_controller.dart';
import 'book_build_widget.dart';

class BooksBuild extends StatelessWidget {
  final bool showAllBooks;

  BooksBuild({super.key, required this.showAllBooks});

  final bookCtrl = AllBooksController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: BeigeContainer(
              width: MediaQuery.sizeOf(context).width,
              color: Theme.of(context).colorScheme.surface.withOpacity(.15),
              myWidget: showAllBooks
                  ? DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          const Gap(24),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              height: 35,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                border: Border.all(
                                  width: 1,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  customSvg(
                                    SvgPath.svgSyntactic,
                                    height: 25,
                                  ),
                                  const Gap(16),
                                  Expanded(
                                    child: TabBar(
                                      controller:
                                          bookCtrl.state.tabBarController,
                                      unselectedLabelColor: Colors.grey,
                                      indicatorColor:
                                          Theme.of(context).colorScheme.surface,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      dividerColor: Colors.transparent,
                                      labelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontFamily: 'kufi',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                      unselectedLabelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontFamily: 'kufi',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                      indicator: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                      ),
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
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            child: TabBarView(
                              controller: bookCtrl.state.tabBarController,
                              children: <Widget>[
                                SingleChildScrollView(
                                  child: BookBuildWidget(
                                    title: 'poetry',
                                    booksList: bookCtrl.state.poemBooks,
                                    showAllBooks: showAllBooks,
                                    section: 0,
                                    isFirst: true,
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: BookBuildWidget(
                                    title: 'books',
                                    booksList: bookCtrl.state.books,
                                    showAllBooks: showAllBooks,
                                    section: 1,
                                    isFirst: true,
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: BookBuildWidget(
                                    title: 'explanation',
                                    booksList: bookCtrl.state.explanationBooks,
                                    showAllBooks: showAllBooks,
                                    section: 2,
                                    isFirst: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          BookBuildWidget(
                            title: 'poetry',
                            booksList: bookCtrl.state.poemBooks,
                            showAllBooks: showAllBooks,
                            section: 0,
                            isFirst: true,
                          ),
                          BookBuildWidget(
                            title: 'books',
                            booksList: bookCtrl.state.books,
                            showAllBooks: showAllBooks,
                            section: 1,
                            isFirst: false,
                          ),
                          BookBuildWidget(
                            title: 'explanation',
                            booksList: bookCtrl.state.explanationBooks,
                            showAllBooks: showAllBooks,
                            section: 2,
                            isFirst: false,
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          Transform.translate(
            offset: const Offset(100, 0),
            child: Container(
              height: 32,
              width: 107,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(4))),
              child: Text(
                'books'.tr,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'kufi',
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
