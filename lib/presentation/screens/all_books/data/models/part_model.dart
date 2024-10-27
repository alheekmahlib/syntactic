import 'chapter_model.dart';

class Part {
  final String partNumber;
  final String partName;
  final List<Chapter> chapters;
  int get partFirstPageNum => chapters.first.chapterFirstPageNum;
  int partLastPageNum;

  Part({
    required this.partNumber,
    required this.partName,
    required this.chapters,
    this.partLastPageNum = 404,
  });

  factory Part.fromJson(Map<String, dynamic> json) {
    var chaptersList = (json['Chapter_names'] as List<dynamic>)
        .map((chapter) => Chapter.fromJson(chapter))
        .toList();

    for (int i = 0; i < chaptersList.length - 1; i++) {
      if (i == chaptersList.length - 1) {
        // last chapter page is  the  last page in teh part.
        // chaptersList[i].chapterEndPageNum =
      } else {
        chaptersList[i].chapterEndPageNum =
            chaptersList[i + 1].chapterFirstPageNum - 1;
      }
    }
    return Part(
      partNumber: json['parts_number'] ?? '',
      partName: json['parts_name'] ?? '',
      chapters: chaptersList,
    );
  }

  factory Part.empty() {
    return Part(partNumber: '', partName: '', chapters: []);
  }
}
