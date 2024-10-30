import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/bookmarks_models.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Bookmarks])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());

  static final AppDatabase _instance = AppDatabase._internal();

  factory AppDatabase() => _instance;

  @override
  int get schemaVersion => 1;

  Future<List<BookmarkModel>> getAllBookmarks() => select(bookmarks).get();

  Future<int> insertBookmark(BookmarkModel bookmark) =>
      into(bookmarks).insert(bookmark);

  Future<bool> updateBookmark(BookmarkModel bookmark) =>
      update(bookmarks).replace(bookmark);

  Future<int> deleteBookmark(int id) =>
      (delete(bookmarks)..where((tbl) => tbl.id.equals(id))).go();

  Future<BookmarkModel?> getBookmark(int bookNumber, int chapterNumber) {
    return (select(bookmarks)
          ..where((tbl) =>
              tbl.bookNumber.equals(bookNumber) &
              tbl.chapterNumber.equals(chapterNumber)))
        .getSingleOrNull();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'bookmarksDB.sqlite'));
    return NativeDatabase(file);
  });
}
