class PoemBook {
  String? bookName;
  String? aboutBook;
  String? bookType;
  int? bookNumber;
  List<Chapter>? chapters;

  PoemBook({
    this.bookName,
    this.aboutBook,
    this.bookType,
    this.bookNumber,
    this.chapters,
  });

  factory PoemBook.fromJson(Map<String, dynamic> json) {
    return PoemBook(
      bookName: json['bookName'],
      aboutBook: json['aboutBook'],
      bookType: json['bookType'],
      bookNumber: json['bookNumber'],
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
