import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/beige_container.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/bookmarks_controller.dart';

class BookmarksBuild extends StatelessWidget {
  const BookmarksBuild({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookmarksController>(
      assignId: true,
      builder: (bookmarkCtrl) {
        return Column(
          children: List.generate(
            bookmarkCtrl.bookmarks.getAll().length,
            (index) {
              var bookmark = bookmarkCtrl.allBookmarks[index];
              return Container(
                  height: 125,
                  width: 380,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Dismissible(
                    key: ValueKey<int>(bookmark.id),
                    background: delete(context),
                    onDismissed: (DismissDirection direction) {
                      bookmarkCtrl.removeBookmark(index);
                    },
                    child: GestureDetector(
                      onTap: () async {
                        bookmarkCtrl.onTapBookmarkBuild(index);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: BeigeContainer(
                              height: 125,
                              width: 380,
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(.15),
                              myWidget: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      bookmarkCtrl.bookmarks
                                          .getAll()[index]
                                          .bookName!,
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
                                  vDivider(context,
                                      height: 50,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  Expanded(
                                    flex: 8,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        bookmarkCtrl.bookmarks
                                            .getAll()[index]
                                            .poemText!,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontFamily: 'naskh',
                                            // fontWeight:
                                            //     FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            height: 1.5),
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
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  border: Border.all(
                                      width: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface
                                          .withOpacity(.15))),
                              child: Text(
                                bookmarkCtrl.bookmarks
                                    .getAll()[index]
                                    .chapterName!,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'kufi',
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
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
                  ));
            },
          ),
        );
      },
    );
  }
}
