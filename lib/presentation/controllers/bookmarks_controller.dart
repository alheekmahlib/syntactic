import 'package:get/get.dart';

import '../../core/services/services_locator.dart';
import '../screens/bookmark/data/models/bookmarks_models.dart';
import '../screens/bookmark/data/models/objectbox.g.dart';

class BookmarksController extends GetxController {
  final bookmarks = sl<Store>().box<BookmarkModel>();

  @override
  void onInit() {
    bookmarks.getAll();
    super.onInit();
  }

  String? get getLastChapterName {
    var allBookmarks = bookmarks.getAll();

    if (allBookmarks.isEmpty) {
      return "لا يوجد";
    }

    var lastBookmark = allBookmarks.last;
    return lastBookmark.chapterName!.isEmpty
        ? "لا يوجد"
        : lastBookmark.chapterName!;
  }

  String? get getLastBookName {
    var allBookmarks = bookmarks.getAll();

    if (allBookmarks.isEmpty) {
      return "لا يوجد";
    }

    var lastBookmark = allBookmarks.last;
    return lastBookmark.bookName!.isEmpty ? "لا يوجد" : lastBookmark.bookName!;
  }

  String? get getLastPoemText {
    var allBookmarks = bookmarks.getAll();

    if (allBookmarks.isEmpty) {
      return "لا يوجد";
    }

    var lastBookmark = allBookmarks.last;
    return lastBookmark.poemText!.isEmpty ? "لا يوجد" : lastBookmark.poemText!;
  }

  void addBookmark(
      String bookName, String chapterName, String poemText, int chapterNumber) {
    final bookmark = BookmarkModel()
      ..bookName = bookName
      ..chapterName = chapterName
      ..poemText = poemText
      ..chapterNumber = chapterNumber;
    bookmarks.put(bookmark);
    print('added bookmark ${bookmark.id}');
  }
}
