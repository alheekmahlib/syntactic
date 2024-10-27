import 'part_model.dart';

class Book {
  final int bookNumber;
  final String bookType;
  final String bookFullName;
  final String bookName;
  final bool hasChapters;
  final int partsCount;
  final int chapterCount;
  final int pageTotal;
  final String aboutBook;
  final List<Part> parts;

  Book({
    required this.bookNumber,
    required this.bookType,
    required this.bookFullName,
    required this.bookName,
    required this.hasChapters,
    required this.partsCount,
    required this.chapterCount,
    required this.pageTotal,
    required this.aboutBook,
    required this.parts,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    var list = json['parts'] as List;
    List<Part> partsList = list.map((data) => Part.fromJson(data)).toList();

    for (int i = 0; i < partsList.length; i++) {
      if (i == partsList.length - 1) {
        // partEndPage is last page number in the book.
        partsList[i].partLastPageNum = json['PageTotle'];
      } else {
        partsList[i].partLastPageNum = partsList[i + 1].partFirstPageNum - 1;
      }
      partsList[i].chapters.last.chapterEndPageNum =
          partsList[i].partLastPageNum;
    }

    return Book(
      bookNumber: json['bookNumber'],
      bookType: json['bookType'],
      bookFullName: json['bookFullName'],
      bookName: json['bookName'],
      hasChapters: json['hasChapters'],
      partsCount: json['parts_count'],
      chapterCount: json['Chapter_count'],
      pageTotal: json['PageTotle'],
      aboutBook: json['aboutBook'],
      parts: partsList,
    );
  }

  // منشئ فارغ
  factory Book.empty() {
    return Book(
      bookNumber: 0,
      bookType: '',
      bookFullName: '',
      bookName: '',
      hasChapters: true,
      partsCount: 0,
      chapterCount: 0,
      pageTotal: 0,
      aboutBook: '',
      parts: [],
    );
  }
}
