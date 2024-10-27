import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nahawi/core/utils/constants/extensions/svg_extensions.dart';
import 'package:nahawi/presentation/screens/all_books/controller/extensions/books_getters.dart';
import 'package:nahawi/presentation/screens/all_books/controller/extensions/books_storage_getters.dart';
import 'package:pie_menu/pie_menu.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../../../../core/utils/helpers/notifications_manager.dart';
import '../../../../core/widgets/beige_container.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/general_controller.dart';
import '../controller/audio/audio_controller.dart';
import '../controller/books_controller.dart';
import '../widgets/poems/audio_widget.dart';
import '../widgets/poems/poems_build.dart';

class PoemsReadView extends StatelessWidget {
  final int chapterNumber;
  PoemsReadView({super.key, required this.chapterNumber});

  final bookCtrl = AllBooksController.instance;
  final audioCtrl = AudioController.instance;

  @override
  Widget build(BuildContext context) {
    bookCtrl.state.chapterNumber.value = chapterNumber;
    final chapter = bookCtrl
        .state.poemBooks[bookCtrl.state.bookNumber.value].parts.first.chapters;
    final bookName =
        bookCtrl.state.poemBooks[bookCtrl.state.bookNumber.value].bookName;
    // audioCtrl.createPlayList();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
        NotificationManager().updateBookProgress(
            bookName, 'notifyBooksBody'.trParams({'bookName': bookName}), 0);
        Get.back();
      },
      child: PieCanvas(
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
            child: Stack(
              children: [
                PageView.builder(
                    itemCount: chapter.length,
                    onPageChanged: (chapterIndex) {
                      bookCtrl.state.chapterNumber.value = chapterIndex;
                      // audioCtrl.createPlayList();
                    },
                    controller: bookCtrl.poemPageController,
                    itemBuilder: (context, chapterIndex) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        bookCtrl.saveLastRead(
                          chapterIndex + 1,
                          bookCtrl
                              .state
                              .booksList[bookCtrl.state.bookNumber.value + 1]
                              .bookName,
                          bookCtrl
                              .state
                              .booksList[bookCtrl.state.bookNumber.value + 1]
                              .bookNumber,
                          chapter.length,
                          chapter[chapterIndex].chapterName,
                          bookCtrl
                              .state
                              .booksList[bookCtrl.state.bookNumber.value + 1]
                              .bookType,
                        );
                      });
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 16.0,
                              left: 16.0,
                              top: 16.0,
                              bottom: 140.0),
                          child: BeigeContainer(
                              width: MediaQuery.sizeOf(context).width,
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(.15),
                              myWidget: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 16.0),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 40.0),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4))),
                                    child: Text(
                                      chapter[chapterIndex].chapterName,
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        fontFamily: 'kufi',
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  PoemsBuild(
                                    chapterNumber: chapterIndex,
                                  ),
                                ],
                              )),
                        ),
                      );
                    }),
                Obx(() => AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    bottom: audioCtrl.state.audioWidgetPosition.value,
                    width: orientation(
                        context,
                        MediaQuery.sizeOf(context).width,
                        MediaQuery.sizeOf(context).width * .5),
                    child: AudioWidget())),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
