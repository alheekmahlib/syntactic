import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahawi/core/utils/constants/extensions/svg_extensions.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/svg_constants.dart';
import '../../../../controllers/bookmarks_controller.dart';

class PoemsBookmarkWidget extends StatelessWidget {
  final int poemIndex;
  final int bookNumber;
  const PoemsBookmarkWidget(
      {super.key, required this.poemIndex, required this.bookNumber});

  @override
  Widget build(BuildContext context) {
    final bookmarkCtrl = sl<BookmarksController>();
    return Obx(() => bookmarkCtrl.isPoemBookmarked(bookNumber, poemIndex).value
        ? customSvgWithColor(SvgPath.svgBookmark,
            height: 22, color: Theme.of(context).colorScheme.surface)
        : const SizedBox.shrink());
  }
}
