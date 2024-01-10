import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/svg_picture.dart';
import '../../../../controllers/bookmarks_controller.dart';

class PoemsBookmarkWidget extends StatelessWidget {
  final int poemIndex;
  const PoemsBookmarkWidget({super.key, required this.poemIndex});

  @override
  Widget build(BuildContext context) {
    final bookmarkCtrl = sl<BookmarksController>();
    return Obx(() => bookmarkCtrl.allBookmarks.firstWhereOrNull(
                (bookmark) => bookmark.poemNumber == poemIndex + 1) !=
            null
        ? bookmark_logo(context,
            height: 22, color: Theme.of(context).colorScheme.surface)
        : const SizedBox.shrink());
  }
}
