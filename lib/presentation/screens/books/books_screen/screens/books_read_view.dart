import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pie_menu/pie_menu.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/svg_picture.dart';
import '../../../../../core/widgets/beige_container.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../controllers/books_controller.dart';
import '../../../../controllers/general_controller.dart';
import '../widgets/books_bookmark_widget.dart';
import '../widgets/pages_build.dart';
import '/presentation/screens/books/books_screen/widgets/books_chapter_title.dart';

class BooksReadView extends StatelessWidget {
  final int chapterNumber;
  const BooksReadView({super.key, required this.chapterNumber});

  @override
  Widget build(BuildContext context) {
    final bookCtrl = sl<BooksController>();
    bookCtrl.chapterNumber.value = chapterNumber;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: PieCanvas(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            centerTitle: true,
            title: syntactic(context, height: 20),
            backgroundColor: Theme.of(context).colorScheme.background,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            elevation: 0,
            leading: GestureDetector(
                onTap: Get.back,
                child: sl<GeneralController>().checkWidgetRtlLayout(
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Image.asset(
                        'assets/icons/arrow_back.png',
                        color: Theme.of(context).colorScheme.primary,
                      )),
                )),
            leadingWidth: 56,
            actions: [
              Transform.translate(
                  offset: const Offset(0, -7),
                  child: fontSizeDropDown(context)),
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                PageView.builder(
                    itemCount: bookCtrl.currentBook!.pages!.length,
                    onPageChanged: (chapterIndex) {
                      bookCtrl.chapterNumber.value = chapterIndex;
                    },
                    controller: PageController(
                        initialPage: bookCtrl.chapterNumber.value),
                    itemBuilder: (context, chapterIndex) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: BeigeContainer(
                                    width: MediaQuery.sizeOf(context).width,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withOpacity(.15),
                                    myWidget: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            BooksChapterTitle(
                                                chapterIndex: chapterIndex),
                                            BooksBookmarkWidget(
                                                chapterIndex: chapterIndex,
                                                bookType: bookCtrl
                                                    .currentBook!.bookType!),
                                          ],
                                        ),
                                        PagesBuild(
                                          chapterNumber: chapterIndex,
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
