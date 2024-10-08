import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/svg_picture.dart';
import '../../../../controllers/books_controller.dart';
import '../../../../controllers/general_controller.dart';
import '../../../bookmark/data/models/bookmarks_models.dart';
import '../../../bookmark/data/models/objectbox.g.dart';
import '../widgets/book_details.dart';
import '../widgets/books_chapter_build.dart';
import '/core/widgets/widgets.dart';

class DetailsBooksScreen extends StatelessWidget {
  final int bookNumber;
  final String bookName;
  const DetailsBooksScreen(
      {super.key, required this.bookName, required this.bookNumber});

  @override
  Widget build(BuildContext context) {
    final bookCtrl = sl<BooksController>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: syntactic(context, height: 20),
        backgroundColor: Theme.of(context).colorScheme.background,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              sl<Store>().box<BookmarkModel>();
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
        child: bookCtrl.currentBook == null
            ? const Center(child: CircularProgressIndicator())
            : orientation(
                context,
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 120.0, right: 24.0, left: 24.0),
                      child: Column(
                        children: [
                          BookDetails(
                            bookNumber: bookNumber,
                            bookName: bookName,
                            bookType: 'books',
                          ),
                          const Gap(32),
                          const BooksChapterBuild()
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 4,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 120.0),
                          child: BookDetails(
                            bookNumber: bookNumber,
                            bookName: bookName,
                            bookType: 'books',
                          ),
                        ),
                      ),
                    ),
                    const Gap(32),
                    const Expanded(
                        flex: 4,
                        child:
                            SingleChildScrollView(child: BooksChapterBuild())),
                  ],
                )),
      ),
    );
  }
}
