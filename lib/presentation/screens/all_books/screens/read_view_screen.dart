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

  BookReadView({super.key, required this.bookNumber});

  @override
  Widget build(BuildContext context) {
    // تهيئة الـ PageController على الصفحة الحالية قبل البناء
    final initialIndex = booksCtrl.state.currentPageIndex.value;
    if (booksCtrl.state.bPageController.positions.isEmpty ||
        booksCtrl.state.bPageController.initialPage != initialIndex) {
      booksCtrl.state.bPageController = PageController(
        initialPage: initialIndex,
        keepPage: true,
      );
    }
    final bookName = booksCtrl.state.booksList[bookNumber - 1].bookName;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
        NotificationManager().updateBookProgress(
          bookName,
          'notifyBooksBody'.trParams({'bookName': bookName}),
          0,
        );
        Get.back();
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          appBar: _BookReadAppBar(bookName: bookName),
          body: SafeArea(
            child: _BookReadBody(bookNumber: bookNumber, bookName: bookName),
          ),
        ),
      ),
    );
  }
}

class _BookReadAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String bookName;
  const _BookReadAppBar({required this.bookName});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: customSvg(SvgPath.svgSyntactic, height: 20),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          NotificationManager().updateBookProgress(
            bookName,
            'notifyBooksBody'.trParams({'bookName': bookName}),
            0,
          );
          Get.back();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Image.asset(
            'assets/icons/arrow_back.png',
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      leadingWidth: 56,
    );
  }
}

class _BookReadBody extends StatelessWidget {
  final int bookNumber;
  final String bookName;
  final booksCtrl = AllBooksController.instance;

  _BookReadBody({required this.bookNumber, required this.bookName});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PageContent>>(
      future: Future.delayed(const Duration(milliseconds: 600)).then(
        (_) => booksCtrl.getPages(
          bookNumber,
          booksCtrl.getLocalBooks(bookNumber).value ? true : false,
        ),
      ),
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
              Obx(
                () => BooksTopTitleWidget(
                  bookNumber: bookNumber,
                  index: booksCtrl.state.currentPageIndex.value,
                  pages: pages,
                ),
              ),
              Flexible(
                child: _BookPageView(
                  pages: pages,
                  bookName: bookName,
                  bookNumber: bookNumber,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class _BookPageView extends StatelessWidget {
  final List<PageContent> pages;
  final String bookName;
  final int bookNumber;
  final booksCtrl = AllBooksController.instance;

  _BookPageView({
    required this.pages,
    required this.bookName,
    required this.bookNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: booksCtrl.state.bookRLFocusNode,
      onKeyEvent: (node, event) => booksCtrl.controlRLByKeyboard(node, event),
      child: PageView.builder(
        controller: booksCtrl.state.bPageController,
        itemCount: pages.length,
        onPageChanged: (i) => booksCtrl.state.currentPageIndex.value = i,
        itemBuilder: (context, index) {
          final page = pages[index];
          WidgetsBinding.instance.addPostFrameCallback((_) {
            booksCtrl.saveLastRead(
              index,
              bookName,
              bookNumber,
              booksCtrl.state.booksList[bookNumber - 1].pageTotal,
              booksCtrl.getChaptersByPage(bookNumber, index + 1).chapterName,
              booksCtrl.state.booksList[bookNumber - 1].bookType,
            );
          });
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: _BookPageContent(page: page),
            ),
          );
        },
      ),
    );
  }
}

class _BookPageContent extends StatelessWidget {
  final PageContent page;
  final booksCtrl = AllBooksController.instance;
  final generalCtrl = GeneralController.instance;

  _BookPageContent({required this.page});

  @override
  Widget build(BuildContext context) {
    return GetX<GeneralController>(
      builder: (controller) {
        return Theme(
          data: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: context.theme.colorScheme.surface,
              selectionColor:
                  context.theme.colorScheme.surface.withValues(alpha: .2),
              selectionHandleColor: context.theme.colorScheme.surface,
            ),
          ),
          child: SelectionArea(
            child: _BookTextAndFootnotes(
              isTashkil: booksCtrl.state.isTashkil.value,
              page: page,
              fontSize: controller.fontSizeArabic.value,
            ),
          ),
        );
      },
    );
  }
}

class _BookTextAndFootnotes extends StatelessWidget {
  final bool isTashkil;
  final PageContent page;
  final double fontSize;

  const _BookTextAndFootnotes({
    this.isTashkil = true,
    required this.page,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            children: <InlineSpan>[
              TextSpan(
                children: isTashkil
                    ? page.content.toFlutterText()
                    : page.content.removeTashkil(page.content).toFlutterText(),
                style: TextStyle(
                  color: Get.theme.colorScheme.inversePrimary,
                  height: 1.5,
                  fontSize: fontSize,
                  fontFamily: 'naskh',
                ),
              ),
            ],
          ),
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.justify,
        ),
        if (page.footnotes.isNotEmpty) ...[
          context.hDivider(
              width: Get.width,
              color: Get.theme.colorScheme.surface.withValues(alpha: .3)),
          const Gap(12),
          _FootnotesSection(
            footnotes: page.footnotes,
            baseFontSize: fontSize,
          ),
        ],
        const Gap(32),
      ],
    );
  }
}

class _FootnotesSection extends StatelessWidget {
  final List<dynamic> footnotes;
  final double baseFontSize;

  const _FootnotesSection({
    required this.footnotes,
    required this.baseFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...List.generate(footnotes.length, (i) {
          final footnote = footnotes[i]?.toString() ?? '';
          return Padding(
            padding: EdgeInsets.only(top: i == 0 ? 0 : 8),
            child: Text(
              footnote,
              style: TextStyle(
                color:
                    Get.theme.colorScheme.inversePrimary.withValues(alpha: .7),
                height: 1.5,
                fontSize: baseFontSize - 5,
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.justify,
            ),
          );
        }),
      ],
    );
  }
}
