import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/custom_error_snackBar.dart';
import '../screens/all_books/controller/books_controller.dart';
import '../screens/all_books/screens/poems_read_view.dart';
import '../screens/all_books/screens/read_view_screen.dart';
import '../screens/bookmark/data/data_source/database.dart';

class BookmarksController extends GetxController {
  static BookmarksController get instance =>
      Get.isRegistered<BookmarksController>()
          ? Get.find<BookmarksController>()
          : Get.put(BookmarksController());

  final AppDatabase _db = AppDatabase();
  RxList<BookmarkModel> allBookmarks = <BookmarkModel>[].obs;
  RxList<BookmarkModel> bookmarkBooks = <BookmarkModel>[].obs;
  RxList<BookmarkModel> bookmarkPoems = <BookmarkModel>[].obs;

  @override
  void onInit() async {
    separateBookmarkByTypes();
    await getAndSetBookmarks();
    super.onInit();
  }

  Future<void> getAndSetBookmarks() async {
    allBookmarks.value = await _db.getAllBookmarks();
    update();
  }

  RxBool isBookmarked(int bookNumber, int chapterNumber) {
    final result = false.obs;
    allBookmarks
            .where((b) =>
                b.bookNumber == bookNumber && b.chapterNumber == chapterNumber)
            .isNotEmpty
        ? result.value = true
        : result.value = false;
    return result.value.obs;
  }

  RxBool isPoemBookmarked(int bookNumber, int poemNumber) {
    final result = false.obs;
    allBookmarks
            .where(
                (b) => b.bookNumber == bookNumber && b.poemNumber == poemNumber)
            .isNotEmpty
        ? result.value = true
        : result.value = false;
    return result.value.obs;
  }

  void separateBookmarkByTypes() async {
    List<BookmarkModel> bookmarks = await _db.getAllBookmarks();
    for (var b in bookmarks) {
      b.bookType == 'book' ? bookmarkBooks.add(b) : bookmarkPoems.add(b);
    }
  }

  String? get getLastChapterName {
    if (allBookmarks.isEmpty) {
      return "notAvailable".tr;
    }
    var lastBookmark = allBookmarks.last;
    return lastBookmark.chapterName?.isEmpty ?? true
        ? "notAvailable".tr
        : lastBookmark.chapterName;
  }

  String? get getLastBookName {
    if (allBookmarks.isEmpty) {
      return "notAvailable".tr;
    }
    var lastBookmark = allBookmarks.last;
    return lastBookmark.bookName?.isEmpty ?? true
        ? "notAvailable".tr
        : lastBookmark.bookName;
  }

  String? get getLastPoemText {
    if (allBookmarks.isEmpty) {
      return "notAvailable".tr;
    }
    var lastBookmark = allBookmarks.last;
    return lastBookmark.poemText?.isEmpty ?? true
        ? "notAvailable".tr
        : lastBookmark.poemText;
  }

  Future<void> addBookmark(
      String bookName,
      String chapterName,
      String poemText,
      int chapterNumber,
      int bookNumber,
      String bookType,
      int poemNumber) async {
    final bookmark = BookmarkModel(
      bookName: bookName,
      chapterName: chapterName,
      poemText: poemText,
      chapterNumber: chapterNumber,
      bookNumber: bookNumber,
      bookType: bookType,
      poemNumber: poemNumber,
      date: DateTime.now(),
    );
    await _db.insertBookmark(bookmark);
    allBookmarks.add(bookmark);
    update();
    print('added bookmark ${bookmark.id}');
  }

  Future<void> onTapBookmarkBuild(int index) async {
    final bookCtrl = AllBooksController.instance;
    bookCtrl.state.bookNumber.value = allBookmarks[index].bookNumber! - 1;
    Get.to(
      () => allBookmarks[index].bookType == 'poemBooks'
          ? PoemsReadView(chapterNumber: allBookmarks[index].chapterNumber!)
          : BookReadView(bookNumber: allBookmarks[index].bookNumber!),
      transition: Transition.downToUp,
    );
  }

  Future<void> removeBookmark(int bookNumber, int chapterNumber) async {
    final bookmarkToRemove = await _db.getBookmark(bookNumber, chapterNumber);
    if (bookmarkToRemove != null) {
      await _db.deleteBookmark(bookmarkToRemove.id!);
      allBookmarks.removeWhere((bookmark) =>
          bookmark.bookNumber == bookNumber &&
          bookmark.chapterNumber == chapterNumber);
      update();
      Get.context!.showCustomErrorSnackBar('deletedBookmark'.tr, isDone: false);
      print('Bookmark removed successfully');
    } else {
      print('No bookmark found for the given bookNumber and chapterNumber');
    }
  }

  String getChapterOrPage(int i) {
    return allBookmarks[i].poemNumber == -1
        ? '${'page'.tr} | ${allBookmarks[i].chapterNumber}'.convertNumbers()
        : allBookmarks[i].chapterName!;
  }
}
