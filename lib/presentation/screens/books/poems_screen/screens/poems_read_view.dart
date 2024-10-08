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
import '../../widgets/audio_widget.dart';
import '../widgets/poems_build.dart';
import '/presentation/controllers/audio_controller.dart';

class PoemsReadView extends StatelessWidget {
  final int chapterNumber;
  const PoemsReadView({super.key, required this.chapterNumber});

  @override
  Widget build(BuildContext context) {
    final bookCtrl = sl<BooksController>();
    final audioCtrl = sl<AudioController>();
    bookCtrl.chapterNumber.value = chapterNumber;
    // audioCtrl.createPlayList();
    return PieCanvas(
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
        ),
        body: SafeArea(
          child: Stack(
            children: [
              PageView.builder(
                  itemCount: bookCtrl.currentPoemBook!.chapters!.length,
                  onPageChanged: (chapterIndex) {
                    bookCtrl.chapterNumber.value = chapterIndex;
                    audioCtrl.createPlayList();
                  },
                  controller:
                      PageController(initialPage: bookCtrl.chapterNumber.value),
                  itemBuilder: (context, chapterIndex) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 16.0, left: 16.0, top: 16.0, bottom: 140.0),
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
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(4))),
                                  child: Text(
                                    bookCtrl.currentPoemBook!
                                        .chapters![chapterIndex].chapterTitle!,
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
                  bottom: audioCtrl.audioWidgetPosition.value,
                  width: orientation(context, MediaQuery.sizeOf(context).width,
                      MediaQuery.sizeOf(context).width * .5),
                  child: const AudioWidget())),
            ],
          ),
        ),
      ),
    );
  }
}
