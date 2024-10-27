import 'package:get/get.dart';
import 'package:nahawi/core/utils/constants/extensions/convert_number_extension.dart';
import 'package:nahawi/core/utils/constants/extensions/custom_error_snackBar.dart';

import '../../core/services/services_locator.dart';
import '../screens/all_books/controller/books_controller.dart';
import '../screens/all_books/screens/poems_read_view.dart';
import '../screens/all_books/screens/read_view_screen.dart';
import '../screens/bookmark/data/models/bookmarks_models.dart';
import '../screens/bookmark/data/models/objectbox.g.dart';

class BookmarksController extends GetxController {
  static BookmarksController get instance =>
      Get.isRegistered<BookmarksController>()
          ? Get.find<BookmarksController>()
          : Get.put(BookmarksController());
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
    update();
  }

  RxBool isBookmarked(int bookNumber, int chapterNumber) {
    final query = bookmarks
        .query(BookmarkModel_.bookNumber
            .equals(bookNumber)
            .and(BookmarkModel_.chapterNumber.equals(chapterNumber)))
        .build();

    try {
      return (query.findFirst() != null).obs;
    } finally {
      query.close();
    }
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
    update();
    print('added bookmark ${bookmark.id}');
  }

  bool separateBookType(int index) =>
      bookmarks.getAll()[index].bookType == 'poemBooks' ? true : false;

  Future<void> onTapBookmarkBuild(int index) async {
    final bookCtrl = AllBooksController.instance;
    bookCtrl.state.bookNumber.value = bookmarks.getAll()[index].bookNumber!;
    // separateBookType(index)
    //     ? bookCtrl.loadPoemBooks = true
    //     : bookCtrl.loadPoemBooks = false;
    Get.to(
        () => separateBookType(index)
            ? PoemsReadView(
                chapterNumber: bookmarks.getAll()[index].chapterNumber!)
            : BookReadView(bookNumber: bookmarks.getAll()[index].bookNumber!),
        transition: Transition.downToUp);
  }

  void removeBookmark(int bookNumber, int chapterNumber) {
    // بناء استعلام للتحقق من bookNumber و chapterNumber
    final query = bookmarks
        .query(BookmarkModel_.bookNumber
            .equals(bookNumber)
            .and(BookmarkModel_.chapterNumber.equals(chapterNumber)))
        .build();

    // الحصول على النتائج وحذف العلامة المرجعية إن وجدت
    final bookmarkToRemove = query.findFirst();
    if (bookmarkToRemove != null) {
      bookmarks.remove(bookmarkToRemove.id);
      allBookmarks.removeWhere((bookmark) =>
          bookmark.bookNumber == bookNumber &&
          bookmark.chapterNumber == chapterNumber);
      update();
      Get.context!.showCustomErrorSnackBar('bookmarkDeleted'.tr, isDone: false);
      print('Bookmark removed successfully');
    } else {
      print('No bookmark found for the given bookNumber and chapterNumber');
    }

    // تدمير الاستعلام بعد الانتهاء
    query.close();
  }

  String getChapterOrPage(int i) {
    return bookmarks.getAll()[i].poemNumber! == -1
        ? '${'page'.tr} | ${bookmarks.getAll()[i].chapterNumber!}'
            .convertNumbers()
        : bookmarks.getAll()[i].chapterName!;
  }
}
