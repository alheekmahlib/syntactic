import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/helpers/app_text_styles.dart';
import '../controller/books_controller.dart';
import '../controller/extensions/books_getters.dart';
import '../data/models/page_model.dart';
// Removed context extensions; use Theme.of(context) directly to avoid unused import

class ChapterDropdown extends StatelessWidget {
  final int bookNumber;
  final List<PageContent> pages;
  final double maxWidth;
  // للتحكم في تمرير قائمة العناصر داخل الـ Dropdown
  static const double _itemExtent = 25; // تقدير ارتفاع كل عنصر لتمركز دقيق

  const ChapterDropdown({
    super.key,
    required this.bookNumber,
    required this.pages,
    this.maxWidth = 220,
  });

  @override
  Widget build(BuildContext context) {
    final booksCtrl = AllBooksController.instance;
    final book = booksCtrl.state.booksList[bookNumber - 1];
    final chapters = book.parts.expand((p) => p.chapters).toList();

    // في حال عدم توفر فصول نعرض الاسم الحالي كنص فقط
    if (!book.hasChapters || chapters.isEmpty) {
      return Obx(() {
        final chapterName = booksCtrl
            .getChaptersByPage(
                bookNumber, booksCtrl.state.currentPageIndex.value + 1)
            .chapterName;
        return Text(
          chapterName,
          style: AppTextStyles.titleSmall(
            fontSize: 16,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          overflow: TextOverflow.ellipsis,
        );
      });
    }

    final List<int> chapterIndices = List.generate(chapters.length, (i) => i);

    return Obx(() {
      final currentPageInBook = booksCtrl.state.currentPageIndex.value + 1;
      int currentChapterIndex = chapters.indexWhere((c) =>
          currentPageInBook >= c.chapterFirstPageNum &&
          currentPageInBook <= c.chapterEndPageNum);
      if (currentChapterIndex == -1) currentChapterIndex = 0;

      // ScrollController محلي لكل بناء لضمان سلوك متوقع عند الفتح
      final itemsScrollController = ScrollController();

      return Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          height: 35,
          child: CustomDropdown<int>(
            maxlines: 1,
            items: chapterIndices,
            initialItem: currentChapterIndex,
            decoration: CustomDropdownDecoration(
              closedFillColor: Theme.of(context).colorScheme.primaryContainer,
              expandedFillColor: Theme.of(context).colorScheme.primaryContainer,
              closedBorderRadius: BorderRadius.circular(8),
              expandedBorderRadius: BorderRadius.circular(8),
              listItemDecoration: ListItemDecoration(
                selectedColor: Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: 0.3),
              ),
            ),
            // تعيين ارتفاع overlay ثابت لتسهيل حساب التمركز
            overlayHeight: 8 * _itemExtent,
            itemsScrollController: itemsScrollController,
            visibility: (isOpen) {
              if (isOpen) {
                // مرّكز الفصل الحالي في منتصف القائمة قدر الإمكان
                final targetOffset = (currentChapterIndex * (_itemExtent + 18));
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (itemsScrollController.hasClients) {
                    itemsScrollController.jumpTo(
                      targetOffset,
                    );
                  }
                });
              }
            },
            closedHeaderPadding: EdgeInsets.zero,
            itemsListPadding: EdgeInsets.symmetric(horizontal: 8.0),
            excludeSelected: false,
            headerBuilder: (context, item, select) => Text(
              chapters[item].chapterName,
              style: AppTextStyles.titleSmall(
                fontSize: 14,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            listItemBuilder: (context, item, selected, _) => SizedBox(
              height: _itemExtent - 5,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  chapters[item].chapterName,
                  style: AppTextStyles.titleSmall(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: selected ? FontWeight.w500 : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            onChanged: (selected) async {
              if (selected == null) return;
              // تجاهل التغييرات الناتجة عن إعادة البناء عندما لا يتغير الفصل فعليًا
              if (selected == currentChapterIndex) return;
              final targetPageInBook = chapters[selected].chapterFirstPageNum;
              final targetIndex = targetPageInBook - 1;
              final clampedIndex = targetIndex.clamp(0, pages.length - 1);
              if (booksCtrl.state.bPageController.hasClients) {
                await booksCtrl.state.bPageController.animateToPage(
                  clampedIndex,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                );
              } else {
                booksCtrl.state.currentPageIndex.value = clampedIndex;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (booksCtrl.state.bPageController.hasClients) {
                    booksCtrl.state.bPageController.jumpToPage(clampedIndex);
                  }
                });
              }
            },
          ),
        ),
      );
    });
  }
}
