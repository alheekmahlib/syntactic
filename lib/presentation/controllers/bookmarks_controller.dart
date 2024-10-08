import 'package:get/get.dart';

import '../../core/services/services_locator.dart';
import '../screens/bookmark/data/models/bookmarks_models.dart';
import '../screens/bookmark/data/models/objectbox.g.dart';
import '../screens/books/books_screen/screens/books_read_view.dart';
import '../screens/books/poems_screen/screens/poems_read_view.dart';
import '/presentation/controllers/books_controller.dart';

class BookmarksController extends GetxController {
  final bookmarks = sl<Store>().box<BookmarkModel>();
  RxList<BookmarkModel> bookmarkBooks = <BookmarkModel>[].obs;
  RxList<BookmarkModel> bookmarkPoems = <BookmarkModel>[].obs;

  @override
  void onInit() async {
    separateBookmarkByTypes();
    await getAndSetBookmarks();
    super.onInit();
  }

  RxList<BookmarkModel> allBookmarks = <BookmarkModel>[].obs;

  Future<void> getAndSetBookmarks() async {
    allBookmarks.value = await bookmarks.getAllAsync();
  }

  bool findBookBookmarks(int index) {
    final bookCtrl = sl<BooksController>();
    final query = (bookmarks.query(BookmarkModel_.chapterNumber
            .equals(bookCtrl.detailsCtrl.value!.pages![index].pageNumber!)))
        .build();
    query.find();
    return true;
  }

  void separateBookmarkByTypes() {
    for (var b in bookmarks.getAll()) {
      b.bookType == 'book' ? bookmarkBooks.add(b) : bookmarkPoems.add(b);
    }
  }

  String? get getLastChapterName {
    var allBookmarks = bookmarks.getAll();

    if (allBookmarks.isEmpty) {
      return "notAvailable".tr;
    }

    var lastBookmark = allBookmarks.last;
    return lastBookmark.chapterName!.isEmpty
        ? "notAvailable".tr
        : lastBookmark.chapterName!;
  }

  String? get getLastBookName {
    var allBookmarks = bookmarks.getAll();

    if (allBookmarks.isEmpty) {
      return "notAvailable".tr;
    }

    var lastBookmark = allBookmarks.last;
    return lastBookmark.bookName!.isEmpty
        ? "notAvailable".tr
        : lastBookmark.bookName!;
  }

  String? get getLastPoemText {
    var allBookmarks = bookmarks.getAll();

    if (allBookmarks.isEmpty) {
      return "notAvailable".tr;
    }

    var lastBookmark = allBookmarks.last;
    return lastBookmark.poemText!.isEmpty
        ? "notAvailable".tr
        : lastBookmark.poemText!;
  }

  Future<void> addBookmark(
      String bookName,
      String chapterName,
      String poemText,
      int chapterNumber,
      int bookNumber,
      String bookType,
      int poemNumber) async {
    final bookmark = BookmarkModel()
      ..bookName = bookName
      ..chapterName = chapterName
      ..poemText = poemText
      ..chapterNumber = chapterNumber
      ..bookNumber = bookNumber
      ..bookType = bookType
      ..poemNumber = poemNumber;
    bookmarks.put(bookmark);
    allBookmarks.add(bookmark);
    print('added bookmark ${bookmark.id}');
  }

  bool separateBookType(int index) =>
      bookmarks.getAll()[index].bookType == 'poemBooks' ? true : false;

  Future<void> onTapBookmarkBuild(int index) async {
    final bookCtrl = sl<BooksController>();
    bookCtrl.bookNumber.value = bookmarks.getAll()[index].bookNumber!;
    separateBookType(index)
        ? bookCtrl.loadPoemBooks = true
        : bookCtrl.loadPoemBooks = false;
    Get.to(
        () => separateBookType(index)
            ? PoemsReadView(
                chapterNumber: bookmarks.getAll()[index].chapterNumber!)
            : BooksReadView(
                chapterNumber: bookmarks.getAll()[index].chapterNumber! - 1),
        transition: Transition.downToUp);
  }

  void removeBookmark(int index) {
    bookmarks.remove(allBookmarks[index].id);
    allBookmarks.remove(allBookmarks[index]);
    update();
  }
}
