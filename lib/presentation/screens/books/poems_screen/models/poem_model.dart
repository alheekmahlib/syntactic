class Book {
  String? bookName;
  String? aboutBook;
  List<Chapter>? chapters;

  Book({
    this.bookName,
    this.aboutBook,
    this.chapters,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookName: json['bookName'],
      aboutBook: json['aboutBook'],
      chapters: (json['chapters'] as List<dynamic>?)
          ?.map((chapterJson) => Chapter.fromJson(chapterJson))
          .toList(),
    );
  }
}

class Chapter {
  String? chapterTitle;
  String? explanation;
  List<Poem>? poems;

  Chapter({
    this.chapterTitle,
    this.explanation,
    this.poems,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterTitle: json['chapterTitle'],
      explanation: json['explanation'],
      poems: (json['poems'] as List<dynamic>?)
          ?.map((poemJson) => Poem.fromJson(poemJson))
          .toList(),
    );
  }
}

class Poem {
  int? poemNumber;
  String? firstPoem;
  String? secondPoem;

  Poem({
    this.poemNumber,
    this.firstPoem,
    this.secondPoem,
  });

  factory Poem.fromJson(Map<String, dynamic> json) {
    return Poem(
      poemNumber: json['poemNumber'],
      firstPoem: json['firstPoem'],
      secondPoem: json['secondPoem'],
    );
  }
}

class BookName {
  int number;
  String bookType;
  String name;

  BookName({required this.name, required this.bookType, required this.number});

  factory BookName.fromJson(Map<String, dynamic> json) {
    return BookName(
        number: json['number'], bookType: json['bookType'], name: json['name']);
  }
}
