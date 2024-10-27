import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:nahawi/core/utils/constants/extensions/extensions.dart';
import 'package:nahawi/core/utils/constants/extensions/highlight_extension.dart';
import 'package:nahawi/core/utils/constants/extensions/html_text_span_extension.dart';
import 'package:nahawi/core/utils/constants/extensions/svg_extensions.dart';
import 'package:nahawi/presentation/screens/all_books/controller/extensions/books_getters.dart';
import 'package:nahawi/presentation/screens/all_books/controller/extensions/books_storage_getters.dart';
import 'package:nahawi/presentation/screens/all_books/controller/extensions/books_ui.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../../../../core/utils/helpers/notifications_manager.dart';
import '../../../../core/widgets/shimmer_effect_build.dart';
import '../../../controllers/general_controller.dart';
import '../controller/books_controller.dart';
import '../data/models/page_model.dart';
import '../widgets/books_top_title_widget.dart';

class BookReadView extends StatelessWidget {
  final int bookNumber;
  final booksCtrl = AllBooksController.instance;
  final generalCtrl = GeneralController.instance;

  BookReadView({super.key, required this.bookNumber});

  @override
  Widget build(BuildContext context) {
    final bookName = booksCtrl.state.booksList[bookNumber - 1].bookName;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
        NotificationManager().updateBookProgress(
            bookName, 'notifyBooksBody'.trParams({'bookName': bookName}), 0);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        appBar: AppBar(
          centerTitle: true,
          title: customSvg(SvgPath.svgSyntactic, height: 20),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0,
          leading: GestureDetector(
              onTap: () {
                NotificationManager().updateBookProgress(bookName,
                    'notifyBooksBody'.trParams({'bookName': bookName}), 0);
                Get.back();
              },
              child: sl<GeneralController>().checkWidgetRtlLayout(
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Image.asset(
                      'assets/icons/arrow_back.png',
                      color: Theme.of(context).colorScheme.primary,
                    )),
              )),
          leadingWidth: 56,
        ),
        body: SafeArea(
          child: FutureBuilder<List<PageContent>>(
            future: Future.delayed(const Duration(milliseconds: 600))
                .then((_) => booksCtrl.getPages(
                      bookNumber,
                      booksCtrl.getLocalBooks(bookNumber).value ? true : false,
                    )),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ShimmerEffectBuild();
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No pages available'));
              } else {
                final pages = snapshot.data!;
                return Column(
                  children: [
                    Obx(() => BooksTopTitleWidget(
                          bookNumber: bookNumber,
                          index: booksCtrl.state.currentPageIndex.value,
                          pages: pages,
                        )),
                    Flexible(
                      child: Focus(
                        focusNode: booksCtrl.state.bookRLFocusNode,
                        onKeyEvent: (node, event) =>
                            booksCtrl.controlRLByKeyboard(node, event),
                        child: PageView.builder(
                          controller: booksCtrl.bookPageController,
                          itemCount: pages.length,
                          onPageChanged: (i) =>
                              booksCtrl.state.currentPageIndex.value = i,
                          itemBuilder: (context, index) {
                            final page = pages[index];
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              booksCtrl.saveLastRead(
                                index,
                                bookName,
                                bookNumber,
                                booksCtrl
                                    .state.booksList[bookNumber - 1].pageTotal,
                                booksCtrl
                                    .getChaptersByPage(bookNumber, index + 1)
                                    .chapterName,
                                booksCtrl
                                    .state.booksList[bookNumber - 1].bookType,
                              );
                            });
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                // controller:
                                //     booksCtrl.state.ScrollUpDownBook,
                                child: GetX<GeneralController>(
                                  builder: (generalCtrl) {
                                    return SelectionArea(
                                      child: Column(
                                        children: [
                                          Text.rich(
                                            TextSpan(children: <InlineSpan>[
                                              TextSpan(
                                                children: booksCtrl
                                                        .state.isTashkil.value
                                                    ? page.content
                                                        .buildTextSpansFromHtml()
                                                    : page.content
                                                        .removeTashkil(
                                                            page.content)
                                                        .buildTextSpansFromHtml(),
                                                style: TextStyle(
                                                    color: Get.theme.colorScheme
                                                        .inversePrimary,
                                                    height: 1.5,
                                                    fontSize: generalCtrl
                                                        .fontSizeArabic.value,
                                                    fontFamily: 'naskh'),
                                              ),
                                            ]),
                                            textDirection: TextDirection.rtl,
                                            textAlign: TextAlign.justify,
                                          ),
                                          context.hDivider(width: Get.width),
                                          ...page.footnotes.map((footnote) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                footnote,
                                                style: TextStyle(
                                                  color: Get.theme.colorScheme
                                                      .inversePrimary
                                                      .withOpacity(.5),
                                                  height: 1.5,
                                                  fontSize: generalCtrl
                                                          .fontSizeArabic
                                                          .value -
                                                      5,
                                                ),
                                                textDirection:
                                                    TextDirection.rtl,
                                              ),
                                            );
                                          }).toList(),
                                          const Gap(32),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
