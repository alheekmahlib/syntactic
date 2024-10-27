class Chapter {
  final String chapterName;
  final int chapterFirstPageNum;
  int chapterEndPageNum;
  final int pageTotal;

  Chapter({
    required this.chapterFirstPageNum,
    this.chapterEndPageNum = 404,
    required this.chapterName,
    required this.pageTotal,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapterFirstPageNum: json['page'] ?? 0,
      chapterName: json['text'] ?? '',
      pageTotal: json['PageTotle'] ?? 0,
    );
  }

  factory Chapter.empty() {
    return Chapter(
      chapterFirstPageNum: 0,
      chapterEndPageNum: 0,
      chapterName: '',
      pageTotal: 0,
    );
  }
}
