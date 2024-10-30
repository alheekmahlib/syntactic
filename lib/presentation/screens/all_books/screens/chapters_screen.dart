import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:nahawi/core/utils/constants/extensions/svg_extensions.dart';

import '../../../../core/utils/constants/svg_constants.dart';
import '../controller/books_controller.dart';
import '../widgets/book_details_widget.dart';
import '../widgets/books_chapters_build.dart';

class ChaptersPage extends StatelessWidget {
  final int bookNumber;
  final String bookName;
  final String bookType;
  final String aboutBook;

  ChaptersPage(
      {super.key,
      required this.bookNumber,
      required this.bookName,
      required this.bookType,
      required this.aboutBook});

  final booksCtrl = AllBooksController.instance;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
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
              Get.back();
            },
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Image.asset(
                  'assets/icons/arrow_back.png',
                  color: Theme.of(context).colorScheme.primary,
                )),
          ),
          leadingWidth: 56,
        ),
        body: SafeArea(
            child: ListView(
          children: [
            const Gap(8),
            BookDetails(
              bookNumber: bookNumber,
              bookName: bookName,
              bookType: bookType,
              aboutBook: aboutBook,
            ),
            const Gap(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: BooksChapterBuild(
                  bookNumber: bookNumber,
                  bookType: bookType,
                ),
              ),
            ),
            const Gap(16),
          ],
        )),
      ),
    );
  }
}
