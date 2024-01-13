class BooksModel {
  String? bookName;
  String? aboutBook;
  String? bookType;
  int? bookNumber;
  List<BooksPages>? pages;

  BooksModel({
    this.bookName,
    this.aboutBook,
    this.bookType,
    this.bookNumber,
    this.pages,
  });

  factory BooksModel.fromJson(Map<String, dynamic> json) {
    return BooksModel(
      bookName: json['bookName'],
      aboutBook: json['aboutBook'],
      bookType: json['bookType'],
      bookNumber: json['bookNumber'],
      pages: (json['pages'] as List<dynamic>?)
          ?.map((chapterJson) => BooksPages.fromJson(chapterJson))
          .toList(),
    );
  }
}

class BooksPages {
  String? chapterTitle;
  int? pageNumber;
  String? pageText;

  BooksPages({
    this.chapterTitle,
    this.pageNumber,
    this.pageText,
  });

  factory BooksPages.fromJson(Map<String, dynamic> json) {
    return BooksPages(
      chapterTitle: json['chapterTitle'],
      pageNumber: json['pageNumber'],
      pageText: json['pageText'],
    );
  }
}
