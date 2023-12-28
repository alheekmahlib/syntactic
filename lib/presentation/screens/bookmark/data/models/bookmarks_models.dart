import 'package:objectbox/objectbox.dart';

@Entity()
class BookmarkModel {
  @Id()
  int id = 0;

  String? bookName;

  String? chapterName;

  String? poemText;

  int? chapterNumber;

  @Property(type: PropertyType.date) // Store as int in milliseconds
  DateTime? date;

  @Transient() // Ignore this property, not stored in the database.
  int? computedProperty;
}
