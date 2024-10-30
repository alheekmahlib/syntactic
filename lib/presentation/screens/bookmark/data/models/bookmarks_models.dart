import 'package:drift/drift.dart';

@DataClassName('BookmarkModel')
class Bookmarks extends Table {
  IntColumn get id => integer().nullable().autoIncrement()();
  TextColumn get bookName => text().nullable()();
  TextColumn get chapterName => text().nullable()();
  TextColumn get poemText => text().nullable()();
  IntColumn get chapterNumber => integer().nullable()();
  IntColumn get bookNumber => integer().nullable()();
  TextColumn get bookType => text().nullable()();
  IntColumn get poemNumber => integer().nullable()();
  DateTimeColumn get date => dateTime().nullable()();
}
