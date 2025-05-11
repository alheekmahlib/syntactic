import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nahawi/core/utils/constants/extensions/extensions.dart';
import 'package:nahawi/core/utils/constants/extensions/html_text_span_extension.dart';
import 'package:nahawi/core/utils/constants/extensions/svg_extensions.dart';

import '../../../../core/utils/constants/svg_constants.dart';
import '../../../../core/widgets/beige_container.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/bookmarks_controller.dart';

class BookmarksBuild extends StatelessWidget {
  BookmarksBuild({super.key});

  final bookmarkCtrl = BookmarksController.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => bookmarkCtrl.allBookmarks.isEmpty
          ? customSvg(SvgPath.svgNoBookmarked, width: Get.width)
          : Column(
              children: List.generate(
                bookmarkCtrl.allBookmarks.length,
                (index) {
                  var bookmark = bookmarkCtrl.allBookmarks[index];
                  return GetBuilder<BookmarksController>(
                    assignId: true,
                    builder: (bookmarkCtrl) => Container(
                        height: 125,
                        width: 380,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Dismissible(
                          key: ValueKey<int>(bookmark.chapterNumber!),
                          background: delete(context),
                          onDismissed: (DismissDirection direction) {
                            bookmarkCtrl.removeBookmark(
                                bookmark.bookNumber!, bookmark.chapterNumber!);
                          },
                          child: GestureDetector(
                            onTap: () async =>
                                await bookmarkCtrl.onTapBookmarkBuild(index),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
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
                                            bookmarkCtrl
                                                .allBookmarks[index].bookName!,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontFamily: 'kufi',
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                height: 1.5),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        context.vDivider(
                                            height: 50,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                        Expanded(
                                          flex: 8,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: RichText(
                                              text: TextSpan(
                                                children: bookmarkCtrl
                                                    .allBookmarks[index]
                                                    .poemText!
                                                    .buildTextSpansFromHtml(),
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontFamily: 'naskh',
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    height: 1.5),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.justify,
                                              textDirection: TextDirection.rtl,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Transform.translate(
                                  offset: Offset(-45.w, 45.h),
                                  child: Container(
                                    height: 32,
                                    width: 220,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4)),
                                        border: Border.all(
                                            width: 1,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface
                                                .withValues(alpha: .15))),
                                    child: Text(
                                      bookmarkCtrl.getChapterOrPage(index),
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: 'kufi',
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
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
                        )),
                  );
                },
              ),
            ),
    );
  }
}
